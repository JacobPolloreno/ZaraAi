#!/bin/bash

echo "Office Answers Project"
echo "----------------------"

py=python3
py36_error_msg="Python 3.6 is not installed.\nPlease install or modify this script to use proper Python executable"

if command -v $py &>/dev/null; then
	py_version=$($py -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
	if [[ "$py_version" != '3.6' ]]; then
		echo -e $py36_error_msg
		exit -1
	fi
else
	echo -e $py36_error_msg
	exit -1
fi

if $py -c 'import pkgutil; exit(not pkgutil.find_loader("virtualenv"))'; then
	echo 'virtualenv not found. Do pip install virtualenv'
	exit 1
fi

echo "Creating virtual environment for project..."
virtualenv venv
source ./venv/bin/activate

echo "Installing dependencies..."
git clone https://github.com/JacobPolloreno/MatchZoo.git
python MatchZoo/setup.py install
pip install -r build/requirements.txt
$py -c "import nltk;nltk.download('stopwords');nltk.download('punkt')"

echo "Downloading dataset..."
cd data/raw/
wget https://download.microsoft.com/download/E/5/F/E5FCFCEE-7005-4814-853D-DAA7C66507E0/WikiQACorpus.zip
unzip WikiQACorpus.zip

echo "Preparing WIKIAQ dataset..."
cd ../..
$py ./data/prepare_wikiqa.py

echo "Done"
