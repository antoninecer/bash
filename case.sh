#! /bin/bash

den=$(date|awk '{print $1}')

case $den in
    "Mon")
        echo "Pondělí:Tak dnes máme před sebou celý, celičký a dlouhý týden, hezký den."         
        ;;
    "Tue")
        echo "Úterý:Je to dnes ale krásný výhled na ten zbytek pracovního týdne, hezký den."         
        ;;
    "Wed")
        echo "Středa:Tak jsme uprostřed týdne, ještě make, ale těš se na večer, hezký den."         
        ;;
    "Thu")
        echo "Čtvrtek:Tak už si plánuj, co bude za akci o víkendu, hezký den."         
        ;;
    "Fri")
        echo "Pátek:Těch pár hodin to ještě dáš, hezký den."         
        ;;
    "Sat")
        echo "Sobota:Tak jestli jsi vůbec spal/a tak hezký den."         
        ;;
    "Sun")
        echo "Neděle:Tak dnes už brzdíme, zítra se de do rachoty, hezký den."         
        ;;
esac

