(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using ModelSelectionGUI

load_envvars(".env")
start()
