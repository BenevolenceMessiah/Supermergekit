@echo off
setlocal

:::  ________  _______   ________   _______   ___      ___ ________  ___       _______   ________   ________  _______      
::: |\   __  \|\  ___ \ |\   ___  \|\  ___ \ |\  \    /  /|\   __  \|\  \     |\  ___ \ |\   ___  \|\   ____\|\  ___ \     
::: \ \  \|\ /\ \   __/|\ \  \\ \  \ \   __/|\ \  \  /  / | \  \|\  \ \  \    \ \   __/|\ \  \\ \  \ \  \___|\ \   __/|    
:::  \ \   __  \ \  \_|/_\ \  \\ \  \ \  \_|/_\ \  \/  / / \ \  \\\  \ \  \    \ \  \_|/_\ \  \\ \  \ \  \    \ \  \_|/__  
:::   \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \    / /   \ \  \\\  \ \  \____\ \  \_|\ \ \  \\ \  \ \  \____\ \  \_|\ \ 
:::    \ \_______\ \_______\ \__\\ \__\ \_______\ \__/ /     \ \_______\ \_______\ \_______\ \__\\ \__\ \_______\ \_______\
:::     \|_______|\|_______|\|__| \|__|\|_______|\|__|/       \|_______|\|_______|\|_______|\|__| \|__|\|_______|\|_______|
::: 
:::  _____ ______   _______   ________   ________  ___  ________  ___  ___     
::: |\   _ \  _   \|\  ___ \ |\   ____\ |\   ____\|\  \|\   __  \|\  \|\  \    
::: \ \  \\\__\ \  \ \   __/|\ \  \___|_\ \  \___|\ \  \ \  \|\  \ \  \\\  \   
:::  \ \  \\|__| \  \ \  \_|/_\ \_____  \\ \_____  \ \  \ \   __  \ \   __  \  
:::   \ \  \    \ \  \ \  \_|\ \|____|\  \\|____|\  \ \  \ \  \ \  \ \  \ \  \ 
:::    \ \__\    \ \__\ \_______\____\_\  \ ____\_\  \ \__\ \__\ \__\ \__\ \__\
:::     \|__|     \|__|\|_______|\_________\\_________\|__|\|__|\|__|\|__|\|__|
:::                             \|_________\|_________|
::: ___  ________   ________  _________  ________  ___       ___       _______   ________     
::: |\  \|\   ___  \|\   ____\|\___   ___\\   __  \|\  \     |\  \     |\  ___ \ |\   __  \    
::: \ \  \ \  \\ \  \ \  \___|\|___ \  \_\ \  \|\  \ \  \    \ \  \    \ \   __/|\ \  \|\  \   
:::  \ \  \ \  \\ \  \ \_____  \   \ \  \ \ \   __  \ \  \    \ \  \    \ \  \_|/_\ \   _  _\  
:::   \ \  \ \  \\ \  \|____|\  \   \ \  \ \ \  \ \  \ \  \____\ \  \____\ \  \_|\ \ \  \\  \| 
:::    \ \__\ \__\\ \__\____\_\  \   \ \__\ \ \__\ \__\ \_______\ \_______\ \_______\ \__\\ _\ 
:::     \|__|\|__| \|__|\_________\   \|__|  \|__|\|__|\|_______|\|_______|\|_______|\|__|\|__|
:::                    \|_________|

for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A

:: Play background music from audio
cd audio
set "file=New D2.wav"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%file%"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >sound.vbs
start /min sound.vbs
cd ..

timeout /t 3

:: Download the code
echo As-salamu alaykum!!
echo detecting presence of repo, git cloning if not detected...
echo ---------------------------------------------------------------
if exist docs\ goto Menu1
git clone https://github.com/BenevolenceMessiah/mergekit.git
cd mergekit
git pull
echo ---------------------------------------------------------------

:Menu1
echo ---------------------------------------------------------------
echo            Please choose from the following options:                     
echo ---------------------------------------------------------------
echo Note:
echo - These options are all case sensitive.
echo - Launching remotely may be advantageous for merging larger models
echo - Press Ctrl+c to exit at any time!
echo ---------------------------------------------------------------
echo 1) Install
echo A) Install additional optional tools (unsloth and supermerger)
echo 2) Launch locally via Gradio
echo 3) Launch locally via Jupyter Notebook
echo 4) Launch remotley via Google Colab Notebook
echo 5) Launch remotley via HuggingFace Space
echo L) Login to HuggingFace (for saving models and accessing gated models.)
echo E) Run LoRA extraction
echo T) Run model/LoRA/QLoRA training via unsloth Google Colab Notebook
echo C) Exit
echo U) Update
echo S) Play music via standalone cmd console while you wait for things to install/download/merge!

set /P option=Enter your choice:
if %option% == 1 goto Install
if %option% == A goto InstallExtra
if %option% == 2 goto Run
if %option% == 3 goto RunNotebookLocal
if %option% == 4 goto RunNotebookRemote
if %option% == L goto Login
if %option% == E goto Extraction
if %option% == T goto Training
if %option% == C goto End
if %option% == U goto Updater
if %option% == S goto Music

:Install
echo Creating virtual environment
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
echo Installing python requirements from requirements.txt and extra junk to make this work on Windows in one file.
echo ---------------------------------------------------------------
python.exe -m pip install --upgrade pip
:: python3 -m pip install --upgrade pip
pip install -e .
:: pip install --upgrade torch torchvision
pip install -r requirements.txt
:: pip install numpy 2.0.1
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu124
echo installed!
echo ---------------------------------------------------------------
goto Menu1

:InstallExtra
echo Creating virtual environment
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
echo Installing unsloth and supermerger
git clone https://github.com/BenevolenceMessiah/unsloth.git
cd unsloth
git pull
start call Install-unsloth.bat
cd ..
git clone https://github.com/BenevolenceMessiah/stable-diffusion-webui.git supermerger
cd supermerger
git pull
set COMMANDLINE_ARGS= --xformers --no-half --no-half-vae --api --opt-split-attention --precision full --port 7861 --autolaunch
:: if not exist extensions mkdir extensions
cd extensions
git clone https://github.com/BenevolenceMessiah/supermerger.git
cd ..
start call webui-user.bat
cd ..
echo installed!
echo ---------------------------------------------------------------
goto Menu1

:Login
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
call huggingface-cli login
goto Menu1

:Extraction
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
echo Mergekit allows extracting PEFT-compatible low-rank approximations of finetuned models.
echo In the new cmd window that launched, paste the following code snippet and edit for your extraction:
echo mergekit-extract-lora finetuned_model_id_or_path base_model_id_or_path output_path [--no-lazy-unpickle] --rank=desired_rank
start call mergekit-extract-lora
goto Menu1

:Updater
echo Updating everything!
ls | xargs -I{} git -C {} pull
echo ---------------------------------------------------------------
goto Menu1

:Run
echo Running mergekit!
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
python mergekit --help
start call python app.py
goto Menu1

:RunNotebookLocal
echo Running mergekit!
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
:: echo installing Jupyter dependencies...
:: pip install jupyter
python mergekit --help
:: start call jupyter nbconvert --execute notebook.ipynb
start call jupyter notebook notebook.ipynb
goto Menu1

:RunNotebookRemote
echo Running mergekit via Google Colab Runtime!
echo ---------------------------------------------------------------
if not exist venv (
    py -3.10 -m venv .venv
) else (
    echo Existing venv detected. Activating.
)
echo Activating virtual environment
call .venv\Scripts\activate
echo ---------------------------------------------------------------
python mergekit --help
:: start start https://drive.google.com/file/d/1TcXuBLbGMsuDazv5eEuVc7rgXVNKsJ__/view?usp=sharing
start start https://colab.research.google.com/drive/1TcXuBLbGMsuDazv5eEuVc7rgXVNKsJ__
goto Menu1

:Training
echo Running training via unsloth Google Colab Notebook...
start start https://colab.research.google.com/drive/1Ys44kVvmeZtnICzWz0xgpRnrIOjZAuxp?usp=sharing
goto Menu1

:Music
echo Installing music dependencies if not installed...
echo ---------------------------------------------------------------
if not exist Audio_Assets git clone https://github.com/BenevolenceMessiah/Audio_Assets.git
cd Audio_Assets
echo 
start call launch_in_standalone_console.bat
cd ..
cd ..
go to Menu1

:End 
echo ---------------------------------------------------------------
echo As-salamu alaykum!!
echo ---------------------------------------------------------------
pause