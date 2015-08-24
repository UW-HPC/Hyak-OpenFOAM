# Hyak-OpenFOAM
scripts for running OpenFOAM on Hyak


Usually you can compile codes within an interactive session. Here are instructions to compile OpenFOAM within an interactive session, and in later sections we will use alternate approach by wrapping all these commands within a 
single script and submitting the compile job to the queuing system.

Start an interactive session in specified group:

    qsub -W group_list=hyak-stf -l walltime=6:00:00,nodes=1:ppn=16,feature=intel -I

You can also request to use a build node, although it does not seem necessary to compile some codes. The advantage of build node is that they have internet access, which is useful if you are using version control for your code 
(like git, subversion, mercurial) and need to push your code to repositories outside Hyak's network. To request build node:

    qsub -W group_list=hyak-stf -l walltime=8:00:00,nodes=1:ppn=16,feature=intel -q build -I

Clone the latest version of OpenFOAM into your gscratch directory

    mkdir /gscratch/stf/$USER/OpenFOAM
    cd /gscratch/stf/$USER/OpenFOAM
    module load git_2.4.4
    git clone https://github.com/OpenFOAM/OpenFOAM-2.4.x.git
    cd /gscratch/stf/$USER/OpenFOAM/OpenFOAM-2.4.x

Edit OpenFOAM's customized "bashrc" file and edit the variable which controls the directory where OpenFOAM compiles. You should see the OpenFOAM logo at the top of this bash file. If you don't see this logo, you are accessing a 
system wide bash file (don't do this).

    vim /gscratch/stf/$USER/OpenFOAM/OpenFOAM-2.4.x/etc/bashrc

So that it compiles in your user directory, in this bashrc file change the variable to:

    foamInstall=/gscratch/stf/$USER/$WM_PROJECT

Before loading up OpenFOAM's bashrc file, we should load all the modules needed by OpenFOAM, which is a compiler and MPI library. Most common choices are either GCC or Intel in combination with OpenMPI. However, modern versions 
of OpenFOAM require a newer version of GCC compilers that are not yet available on Hyak, so must resort to using the Intel compilers. Load the modules:

    module load icc_15.0.3-impi_5.0.3
    module load cmake_3.2.3

Now we can source OpenFOAM's bashrc file to set all environmental variables. Note, you may need to hardcode your user name instead of using the variable $USER, in case it is not already set. For reference, here is included a 
workable OpenFOAM bashrc file for using Intel compiler and Intel MPI: [bashrc.sh]

    source /gscratch/stf/$USER/OpenFOAM/OpenFOAM-2.4.x/etc/bashrc

Run the OpenFOAM build script, and pipe the output into a log file to track any error messages:

    ./Allwmake 2>&1 | tee log.compile-OpenFOAM

OpenFOAM should now be compiled, and now run some tutorial cases just to make sure!

OpenFOAM can take a long time to compile, and using an interactive session might not allow enough wall-time to complete the compilation. An alternative approach is to combine these commands into a single PBS script and submit a 
job as normal. Here is an example PBS script that should compile OpenFOAM: [Hyak-compile-OpenFOAM.sh] Make sure this file is executable:

    chmod +x Hyak-compile-OpenFOAM.sh

Now just submit this script to the queue via the command:

    qsub ./Hyak-compile-OpenFOAM.sh

