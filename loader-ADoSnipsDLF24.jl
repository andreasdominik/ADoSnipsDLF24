# main loader skill script.
#
# Normally, it is NOT necessary to change anything in this file,
# unless you know what you are doing!
# The file is adapted by the init script.
#
# A. Dominik, May 2019, © GPL3
#

APP_DIR = @__DIR__
include("$APP_DIR/Skill/ADoSnipsDLF24.jl")
import Main.ADoSnipsDLF24

global INTENT_ACTIONS
append!(INTENT_ACTIONS, ADoSnipsDLF24.getIntentActions())
