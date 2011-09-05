#! /bin/bash
# find . -name \*.el -exec emacs --batch -Q -f batch-byte-compile {} \;

emacs="emacs"

target=$(find "${HOME}/.emacs.d" -name \*.el)
elisp=$(find /usr/share/emacs/23.2/ -name \*.el -exec echo -L {} \;)

if [ $? -eq 1 ];
then
    elisp=$(find /Applications/Emacs.app/Contents/Resources/ -name \*.el -exec echo -L {} \;)
    echo "not found: /usr/share/emacs23/site-lisp/"
    
    if [ $? -eq 1 ]
    then
	exit
    fi 
fi

echo "found site-lisp"

sitelisp=()
for e in ${elisp[@]}
do
    sitelisp=(${sitelisp[@]} ${e%/*.el})
done

echo "found libraries"

emacsel="./emacs.el"
root=${HOME}/.emacs.d/
search=(auto-install plugins/yasnippet plugins/twittering-mode  elpa config/tramp/ config/flymake/ config/ispell/)
path=()

for s in ${search[@]}
do
    path=(${path[@]} -L ${root}${s})
done

echo "found user libraries"

echo "Those files will be updated."
for el in ${target[@]};
do
    for ex in ${emacsel};
    do
	if [ $el != $ex ];
	then
	    echo $el;
	fi
    done
done

echo "start byte compiling"

for el in ${target[@]};
do
    flag="True"
    for lst in ${emacsel};
    do
	if [ $el = $lst ];
	then
	    flag="False";
	    break;
	fi
    done

    if [ $flag = "True" ];
    then
	echo "Byte compile ${el}"
	echo "${emacs} --batch ${path[@]} ${sitelisp[@]} -Q -f batch-byte-compile ${el}"
	${emacs} --batch ${path[@]} ${sitelisp[@]} -Q -f batch-byte-compile ${el}
	echo ""
    fi 
done
