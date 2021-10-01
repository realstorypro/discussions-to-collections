# To Deploy to AWS Lambda

0. Install Gems to Vendor
```bash
 bundle config set --local path 'vendor/bundle'
 bundle
```

1. Zip it UP
```bash
 zip -r function.zip lambda_function.rb vendor
```

2. Upload it
```bash
 aws lambda update-function-code --function-name discussions-to-collection --zip-file fileb://function.zip
```