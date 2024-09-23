# Overview

The following checks will be performed on the entered string using Amazon Bedrock.

1. Does the string you entered conform to what is described in the official AWS documentation ( https://aws.amazon.com/jp/premiumsupport/tech-support-guidelines/ ) ?
2. Is the input string sufficient from the 5W2H(What, Who, Where, When, Why,How,How much) perspective?

# Prerequisites

- All input and output is assumed to be in Japanese.
- It is assumed that the Tokyo region (ap-northeast-1) will be used as the AWS region.
- We assume that the aforementioned regions allow model access to Anthropic Claude 3 Haiku.
- If you are using a local machine, use aws configure. If you are using an EC2 instance, make sure that the appropriate instance profile is attached.

## Usage

### Common Processing

1. In your terminal, change to a local directory
2. Clone the repository
    ```bash
    git clone https://github.com/kazzpapa3/CreateInqueryViaBedrock.git
    ```

#### Execution in a shell script

1. If you have just cloned from GitHub, "CreateInqueryViaBedrock" will be created directly under it, so change directory.  
    ```bash
    cd CreateInqueryViaBedrock
    ```
2. In the exec.sh file located directly under the CreateInqueryViaBedrock directory, enter the option "-e" followed by the string you want to query.  
    ```bash
    e.g.) ./exec.sh -e "I haven't been able to connect to AWS since this morning. Is there some kind of problem?"
    ```

#### Execution as single-page application

1. If you have just cloned from GitHub, "CreateInqueryViaBedrock/spa" will be created directly under it, so change directory.  
    ```bash
    cd CreateInqueryViaBedrock/spa
    ```
2. Create a virtual environment for python. The following is an example of virtualenv, but you can also use venv.  
    ```bash
    virtualenv -p python3 .
    ```
3. Activate the virtual environment for Python.  
    ```bash
    source bin/activate
    ```
4. Install the required modules.  
    ```bash
    pip install -r requirements.txt
    ```
5. Run app.py and access http://localhost:5000 in your web browser.
    ```bash
    python app.py
    ```