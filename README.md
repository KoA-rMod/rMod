# rMod

A modding project for Kingdoms of Amaluar: Reckoning. Injectable hook that introduces plugins (via C++/etc.) and addons (via Lua scripting).

# rMod Repositories

rMod is separated into a few repositories to help keep the project clean and have central locations for issue reports for each part separated. 

You can view the full list of repositories here:
  * https://github.com/KoA-rMod
  
Some important repositories that you may wish to view are:

  * Addons: https://github.com/KoA-rMod/Addons
  
Interested in developing plugins for rMod? Check out the example plugin source code here:

  * ExamplePlugin: https://github.com/KoA-rMod/ExamplePlugin

# rMod Community

Join the rMod community on our site (forums) and Discord server!

  * **Forums:** https://koa.atom0s.com/
  * **Discord:** https://discordapp.com/invite/qRg969Q

Be sure to check out the other repositories associated with the rMod project here: https://github.com/KoA-rMod

# Reporting Issues

When reporting an issue about rMod please include as much information as possible. Vague issue reports will likely be ignored or deemed incomplete due to a lack of information. You should include the following information when reporting an issue:

  * Windows Version
  * rMod Version
  * Game Version (Steam, Origin, etc.)
  * Game Version Number (v1.0.0.2, etc.)
  * Detailed explaination of the issue.

You should include details on what you were doing when the issue happened, steps to reproduce the issue, if possible, and so on.

# Pull Requests (For Developers)

If you would like to contribute to the include plain text files of rMod, such as the Lua libraries, please be sure that you are following these key points. Pull requests will be rejected otherwise.

  * Your pull request must specifically state if it contains breaking changes that will affect features of rMod. (Addons, plugins, etc.)
  * Your pull request must detail everything your changes affect.
  * Your pull request must be thoroughly tested before being submitted.
  
Code changes need to follow the following syntax rules:

  * No tabs, use 4 spaces.
  * 'if' statements should be in the format of 'if (statement) then' for Lua code.
  * 'if' statements should be in the format of 'if (statement)' for C++ code.
  * Braces for scope related code in C/C++ code must be on their own line.
  
<!-- lang: C -->

    // Correct
    if (derp == true)
    {
        // code here..
    }
    
    // Incorrect
    if (derp == true) {
        // code here..
    }
