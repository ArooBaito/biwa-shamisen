# Shamisen
Shamisen is a BiwaScheme websocket server that provides support for interactive programming and integration with Emacs, or in other words SLIME integration for BiwaScheme, the Scheme implementation by Yutaka Hara written on top of Javascript/NodeJS. Specifically, this integration is for a live connection to the browser, as the Node version of BiwaScheme can already be accessed using inferior Scheme in Emacs by connecting it to the "biwas" command in the same way Gauche, Gambit, and other Scheme implementations do.

Using Shamisen, you can select any Scheme code in Emacs and have it execute in real-time in the web browser.

# Usage example
Here is a demonstration of a webGL game coded in BiwaScheme on top of PlayCanvas with code being able to be re-written and executed as the game is running:

https://cdn.discordapp.com/attachments/864562446714535978/872241082635780116/shamisen_example.gif

# Installation
The easiest way to install Shamisen is by typing "npm install -g biwa-shamisen" in a console/terminal. Alternatively, you can download the files here, extract them to a directory, and then run "npm install -g ." from within the directory.

Here are the steps necessary for setup:

# Emacs setup (do this once)
Once Shamisen has been installed using the npm command above, open Emacs, press ctrl + X, ctrl + F, then open "~/.emacs". At the bottom, type: 
(setq scheme-program-name "shamisen-emacs") 
to set Shamisen/BiwaScheme as your default Emacs inferior Scheme. Then restart Emacs.

# Per project instructions
First, start the Shamisen server by typing "shamisen" in a command prompt/terminal. Immediately following installation, it might take a minute for the Shamisen server to start as it caches for first-time use, but the following runs will be instantaneous. When successful, it will say "Shamisen started on port 8090". At the moment this port is hard-coded since I haven't bothered to figure out how to feed custom ports from an Emacs inferior Scheme. If you're familiar with that process, feel free to uncomment the lines in the client and the server pertaining to reading the port from the command-line, otherwise I will likely update it with this feature in the future.

Next, install the Shamisen browser client to your project. If you installed Shamisen off of NPM on Windows, the SCM will be in 

C:/users/(your login)/AppData/Roaming/npm/node_modules/biwa-shamisen/bin/Scheme/shamisen-browser.scm

Alternatively you can do a second local npm install of Shamisen and grab the file from there or grab it from this repository. Place the shamisen-browser.scm next to your index.html and edit the index.html as shown:

![image](https://user-images.githubusercontent.com/88218771/128094747-1deb4e03-b1ce-4a1c-a61b-d10d34042436.png)

The important scripts here are "biwascheme.js" in the header of course, and the <script type="text/biwascheme"> section, which loads my game logic from "core.scm" and you can safely ignore, but also it loads "shamisen-browser.scm" which will connect to the Shamisen server that is now running. You can now host the index.html file however you usually do so with an express JS server, a Gauche Makiki server, Python + Flask, etc.
  
When you open the link to your hosted HTML file you will see "Connected to Shamisen server successfully" in the JavaScript console and "Connected to browser successfully" in the Shamisen server console. Now you can open any .scm in Emacs, press ctrl + X, 2 to split the screen into 2 windows, and then run the inferior Scheme from the Scheme menu at the top as shown:

![image](https://user-images.githubusercontent.com/88218771/128095376-15b3d356-4e44-4c61-bc40-b706a72f08a5.png)

"Emacs connected successfully" will appear in the Emacs Scheme prompt as well as in the Shamisen server console. You can now place the cursor at the end of any S-expression and press CTRL + X, CTRL + E to execute it in the browser just as you would with any other SLIME implementation.
  
If you have any questions, feel free to e-mail me at ArooBaitoArt@gmail.com or contact me on Twitter @ArooBaitoArt.
