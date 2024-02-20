#!/bin/bash
#
# Criado por Mauro Augusto Soares Rodrigues
# em 01/02/2024 v2
#
# Script para limpeza de disco utilizando o
# metodo Zero Fill
#
# Muito cuidado com este procedimento, se
# utilizado sem atencao podera ocorrer perda
# de dados irreparaveis, deste modo, utilize com 
# sabedoria
#
#

if [[ -z $1 ]]; then
  echo -e "Por favor, passe a unidade de armazenamento junto ao comando.\n"
  echo -e "usage: sudo ${0} sdX \n"
  echo -e "Onde X devera ser a letra correspondente a unidade de armazenamento a ser limpa.\n"
  echo -e "Para saber qual a unidade de armazenamento\na ser limpa utilize o comando 'sudo fdisk -l'\n"
  echo -e "ATENCAO!! PRESTE MUITA ATENCAO, CASO NAO POSSUA OS CONHECIMENTOS\nNECESSARIOS NAO UTILIZE ESTE COMANDO EM HIPOTESE ALGUMA\nEVITE DOR DE CABECA DESNECESSARIA!!"
  exit 1
fi

function zero_fill() {
  if [[ $1 -eq 1 ]]; then
    #statements
    echo -e "\nATENCAO!! PRESTE MUITA ATENCAO voce esta prestes a limpar uma unidade de armazenamento (HD, pendrive, cartao de memoria, etc)."
    echo "ESTEJA CIENTE QUE ESSA ACAO NAO TEM VOLTA!"
    sleep 10
    read -p "Deseja continuar [s/N]?: " -n 1

    if [[ "${REPLY:=N}" != "${REPLY#[Ss]}" ]]; then
      echo -e "\nIniciando a limpeza zero fill da unidade de armazenamento /dev/${2}..."
      sleep 5
      echo -e "Voce informou a unidade de armazenamento /dev/${2}. Isto esta correto?\nCaso responda afirmativamente, ESTEJA CIENTE QUE, A PARTIR DESTE MOMENTO, ESSA ACAO NAO TEM MAIS VOLTA!\n"
      read -p "Deseja continuar [s/N]?: " -n 1
      if [[ "${REPLY:=N}" != "${REPLY#[Ss]}" ]]; then
        echo -e "\nLimpeza zero fill da unidade de armazenamento /dev/${2} iniciada..."
        sudo dd if=/dev/zero of=/dev/${2} status=progress bs=1M
        return 0
      else
        echo -e "\nAbortando limpeza da unidade de armazenamento /dev/${2}."
        return 1
      fi
    else
      echo -e "\nAbortando limpeza da unidade de armazenamento /dev/${2}."
      return 1
    fi
  else
    echo -e "\nLimpeza zero fill da unidade de armazenamento /dev/${2} iniciada..."
    sudo dd if=/dev/zero of=/dev/${2} status=progress bs=1M
    return 0
  fi
}

function urandom_fill() {
  if [[ $1 -eq 1 ]]; then
    echo -e "\nATENCAO!! PRESTE MUITA ATENCAO voce esta prestes a limpar uma unidade de armazenamento (HD, pendrive, cartao de memoria, etc)."
    echo "ESTEJA CIENTE QUE ESSA ACAO NAO TEM VOLTA!"
    sleep 10
    read -p "Deseja continuar [s/N]?: " -n 1

    if [[ "${REPLY:=N}" != "${REPLY#[Ss]}" ]]; then
      echo -e "\nIniciando a limpeza urandom fill da unidade de armazenamento /dev/${2}..."
      sleep 5
      echo -e "Voce informou a unidade de armazenamento /dev/${2}. Isto esta correto?\nCaso responda afirmativamente, ESTEJA CIENTE QUE, A PARTIR DESTE MOMENTO, ESSA ACAO NAO TEM MAIS VOLTA!\n"
      read -p "Deseja continuar [s/N]?: " -n 1
      if [[ "${REPLY:=N}" != "${REPLY#[Ss]}" ]]; then
        echo -e "\nLimpeza urandom fill da unidade de armazenamento /dev/${2} iniciada..."
        sudo dd if=/dev/urandom of=/dev/${2} status=progress
        return 0
      else
        echo -e "\nAbortando limpeza da unidade de armazenamento /dev/${2}."
        return 1
      fi
    else
      echo -e "\nAbortando limpeza da unidade de armazenamento /dev/${2}."
      return 1
    fi
  else
    echo -e "\nLimpeza urandom fill da unidade de armazenamento /dev/${2} iniciada..."
    sudo dd if=/dev/urandom of=/dev/${2} status=progress
    return 0
  fi
}

while [[ true ]]; do
  echo -e "\nEscolha uma das opcoes a seguir:\n"
  echo "1. Rodar apenas o Zero Fill uma unica vez. (Recomendado aos SSD's)"
  echo "2. Rodar preenchimento urandom 1x e o Zero Fill 1x. (Recomendado aos HDD's)"
  echo "3. Rodar preenchimento urandom 2x e o Zero Fill 1x. (Recomendado aos HDD's)"
  echo "4. Rodar preenchimento urandom 2x e o Zero Fill 2x. (Recomendado aos HDD's)"
  echo -e "5. Encerrar aplicacao.\n"
  read -p "Digite sua opcao [1-5]: " -n 1
  case $REPLY in
    1)
      zero_fill 1 $1
      if [[ $? -eq 0 ]]; then
        echo "Zero fill completado!"
        echo "Caso nao seja mais necessario nenhuma outra execucao de limpeza,"
        echo "Selecione a opcao 5 para encerrar a aplicacao"
        sleep 8
      else
        echo "Zero fill abortado pelo usuario"
      fi
    ;;
    2)
      urandom_fill 1 $1
      if [[ $? -eq 0 ]]; then
        echo "Urandom fill completado!"
      else
        echo "Urandom fill abortado pelo usuario"
      fi
      zero_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Zero fill completado"
        echo "Caso nao seja mais necessario nenhuma outra execucao de limpeza,"
        echo "Selecione a opcao 5 para encerrar a aplicacao"
        sleep 8
      else
        echo "Zero fill abortado pelo usuario"
      fi
    ;;
    3)
      urandom_fill 1 $1
      if [[ $? -eq 0 ]]; then
        echo "Urandom fill completado!"
      else
        echo "Urandom fill abortado pelo usuario"
      fi
      urandom_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Urandom fill completado!"
      else
        echo "Urandom fill abortado pelo usuario"
      fi
      zero_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Zero fill completado"
        echo "Caso nao seja mais necessario nenhuma outra execucao de limpeza,"
        echo "Selecione a opcao 5 para encerrar a aplicacao"
        sleep 8
      else
        echo "Zero fill abortado pelo usuario"
      fi
    ;;
    4)
      urandom_fill 1 $1
      if [[ $? -eq 0 ]]; then
        echo "Urandom fill completado!"
      else
        echo "Urandom fill abortado pelo usuario"
      fi
      urandom_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Urandom fill completado!"
      else
        echo "Urandom fill abortado pelo usuario"
      fi
      zero_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Zero fill completado"
      else
        echo "Zero fill abortado pelo usuario"
      fi
      zero_fill 0 $1
      if [[ $? -eq 0 ]]; then
        echo "Zero fill completado"
        echo "Caso nao seja mais necessario nenhuma outra execucao de limpeza,"
        echo "Selecione a opcao 5 para encerrar a aplicacao"
        sleep 8
      else
        echo "Zero fill abortado pelo usuario"
      fi
    ;;
    5)
      echo -e "\nEncerrando aplicacao..."
      break
    ;;
    *)
      echo -e "\n\nOpcao inexistente, por gentileza, escolher uma opcao"
      echo "entre os numerais um (1) ao cinco (5)."
      sleep 5
    ;;
  esac
done

exit 0
