#!/bin/bash

#Pickup newer ruby which was installed via rvm
source /etc/profile.d/rvm.sh

# Install required cocoapods
cocoapods_version=1.9.3
rvmsudo gem uninstall --all cocoapods
rvmsudo gem install cocoapods -v ${cocoapods_version}
mkdir $HOME/.gem
export GEM_HOME=$HOME/.gem
gem which cocoapods

# virtualenv stuff
export LC_ALL=C
export LANG=en_US.UTF-8

pip3 install --user --upgrade virtualenv

# start virtualenv
/home/couchbase/.local/bin/virtualenv COCOAPODS || exit 1
source ./COCOAPODS/bin/activate  || exit 1

# Checkout required repo
cd ${WORKSPACE} && git clone git@github.com:couchbaselabs/couchbase-lite-ios-ee.git couchbase-lite-ios-ee
cd couchbase-lite-ios-ee
git checkout ${BRANCH}

cd ${WORKSPACE}/couchbase-lite-ios-ee/Podspecs
declare -a JSON_FILES=( $(ls) )
for fl in "${JSON_FILES[@]}"; do
	python3 ${WORKSPACE}/build/scripts/jenkins/lite-ios/cocoapods-publish.py --version ${VERSION} --file $fl || exit 1
done

# deactivate virtualenv
echo "Deactivating virtualenv ..."
deactivate
echo
