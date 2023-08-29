#!/usr/bin/env bash
# ###################################################################
#    SCRIPT DE CREACION DEL ENTORNO BASICO DE ORACLE PARA DBAs
# ###################################################################

export cfgDir=$HOME/configuracion
export envFile=$cfgDir/entorno.cfg


[[ ! -d $cfgDir ]] && mkdir -p $cfgDir
[[ -r $envFile ]] && {
    echo -e "ERROR:\n\nEl fichero de entorno existe. Por seguridad se cancela la ejecucion y no se realiza ningun cambio\n"
    exit 1
}

which screen > /dev/null 2>&1
[[ $? -eq 0 ]] && {
    export bloqueExtras1=$(echo -e "alias scl='screen -ls'\nalias sc='screen -DRS'")
} || {
    export bloqueExtras1=$(echo -e "#alias scl='screen -ls'\n#alias sc='screen -DRS'")
}

which rlwrap > /dev/null 2>&1
[[ $? -eq 0 ]] && {
    export bloqueExtras2=$(echo -e "alias sqlplus='rlwrap sqlplus'\nalias rman='rlwrap rman'")
} || {
    export bloqueExtras2=$(echo -e "#alias sqlplus='rlwrap sqlplus'\n#alias rman='rlwrap rman'")
}




# Creamos el fichero de configuracion de entorno

cat << EOF >> $envFile
######################################################################
#          FICHERO DE CONFIGURACION BASICO DEL DBA ORACLE
######################################################################
#  Este es el fichero de configuracion del entorno para DBAs
#  Segun esta aplica la configuracion basica pero si se instalan
#  los siguientes paquetes, se puede mejorar bastante
#
#   rlwrap
#   screen 
#   glances
#   (python) jupyter labs
#   (python) modulos cxoracle, pandas, numpy
#   neovim
#   wtee
#
#   Si tenemos entorno grafico:
#   visual studio code
#   sqlDeveloper
#  
# ZONA DE FUNCIONES
# -------------------------------------------

function verpmon()
{
    ps -ef|grep pmon|grep -v grep
}

function entorno()
{
    echo -e "\n========================================================================================" 
    echo "                          DATOS DEL ENTORNO CARGADO EN MEMORIA" 
    echo "========================================================================================" 
    echo -e "         Este script SOLO MUESTRA el entorno cargado, NO LO CAMBIA!!!!!!!!\n\n" 
    echo "            ORACLE_SID.......: $ORACLE_SID" 
    echo "            ORACLE_UNQNAME...: $ORACLE_UNQNAME" 
    echo "            ORACLE_BASE......: $ORACLE_BASE" 
    echo "            ORACLE_HOME......: $ORACLE_HOME" 
    echo "            LD_LIBRARY_PATH..: $LD_LIBRARY_PATH" 
    echo "            TNS_ADMIN........: $TNS_ADMIN" 
    echo "            ------------- PATH -------------" 
    OIFS=\$IFS 
    IFS=':' 
    for ruta in \$PATH 
    do 
    echo "            \$ruta" 
    done 
    IFS=\$OIFS 
    echo -e "\n\n" 
    echo "=========================================================================================" 
    echo
}

# ZONA DE VARIABLES
# ------------------------------------------
export ORACLE_SID=XXX
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export TNS_ADMIN=$ORACLE_HOME/network/admin
export PATH=$PATH:$ORACLE_HOME/bin
export OH=$ORACLE_HOME

# ZONA DE ALIAS
# -------------------------------------------
alias ll='ls -larth --color=auto'
alias grep='grep --color=auto'
alias duu='du -scBM *|sort -n'
alias duuu='du -amx *|sort -nr|head -20'
${bloqueExtras1}
${bloqueExtras2}
alias sq='sqlplus / as sysdba'

EOF

