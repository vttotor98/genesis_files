
#!/bin/bash
#Author Victor TIREBAQUE for Agaetis Clermont-Ferrand

#Démarage du premier noeuds, vérifier les paramètres
fichier=.param_blch
#Est-ce que le fichier de paramètre existe, et est-il vide
if [ ! -s $fichier ]; then
  #Comme il n'existe pas de fichier de paramètrage
  #Nous le créons en demandant les paramètres à l'utilisateur
  echo "Comment vous voulez appeller ce noeud ?"
  read node_name
  echo "Quel sera l'idnetwork ?"
  read idnet

  #Création du fichier .param_blch
  touch $fichier
  chmod 755 .param_blch
  echo $node_name >.param_blch
  echo $idnet >>.param_blch
else
  #Comme il existe nous récupérons les données
  declare -a tab
  i=0
  #Lecture dans le fichier .param_blch
  while IFS='' read -r line || [[ -n "$line" ]]; do
    tab[i]=$line
    i=`expr $i + 1`
  done < .param_blch

  node_name=${tab[0]}
  idnet=${tab[1]}

fi


#Initialisation de démarrage et redirection du fichier nohup.out dans geth.log
geth --identity $node_name init ~/blockchain/genesis_folder/genesis.json --datadir ~/blockchain/.ethereum_private/ACPrivateChain
nohup geth --datadir ~/blockchain/.ethereum_private/ACPrivateChain --networkid $idnet --nodiscover &>>/geth.log &


#Don des droits en lecture
chmod +r geth.log