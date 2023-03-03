X=""
for i in $(git diff --dirstat=files,0 main..HEAD|cut -d'%' -f 2|cut -d' ' -f 2|grep aws)
do
    X="$X,\"$i\""
    cat << EOF > ${i}/backend.tf
    terraform {
    backend "s3" {
        bucket = "deriv-playground-iac-states"
        key    = "${i}"
        region = "us-east-1"
    }
    }
EOF
done
X="${X:1}"
