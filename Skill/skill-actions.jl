#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips Console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# * MQTT-Topic as String
# * MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style)
#

"""
function readNews(topic, payload)

        read the news from DLF24
"""
function readNews(topic, payload)

    println("- ADoSnipsDLFnews: action readNews() started.")

    if ! Snips.tryrun(`$DOWNLOAD_SCRIPT`, wait = false, errorMsg = "")
        Snips.publishEndSession("Ich kann die Nachrichten nicht von DLF24 abrufen!")
        return false
    end

    Snips.publishSay("""Ich rufe die neuesten Nachrichten von DLF ab!
                     Nach jeder Zusammenfassung kannst Du JA sagen,
                     um die vollständige Meldung zu hören oder Abbruch
                     oder Ende um
                     die Nachrichten zu beenden.""",
                     lang = "de", wait = true)

    news = Snips.tryParseJSONfile("dlf.json")

    for i in 1:length(news)

        one = news[Symbol(i)]

        # prepare full text:
        shell = `$DOWNLOAD_FULL_SCRIPT $i $(one[:link])`
        Snips.tryrun(shell, wait = false)

        #Snips.publishSay(one[:date])
        Snips.publishSay(one[:title], lang = "de")
        Snips.publishSay(one[:description], lang = "de")

        answer = Snips.askYesOrNoOrUnknown("")
        if answer == :yes
            Snips.publishSay("Die vollständige Meldung:", lang = "de")
            text = Snips.tryReadTextfile("dlf_$i.txt")
            length(text) > 0 && Snips.publishSay(text, lang = "de")
        elseif answer == :no
            Snips.publishSay("OK. Abbruch!", lang = "de")
            break
        end

        if Snips.askYesOrNoOrUnknown("") == :no
            Snips.publishSay("OK. Abbruch!", lang = "de")
            break
        end
    end

    Snips.publishEndSession("Keine weiteren Nachrichten!")
    return false
end
