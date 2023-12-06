import boto3
from botocore.exceptions import NoCredentialsError

def upload_to_s3(file_path, bucket_name, object_name):
    s3 = boto3.client('s3')

    try:
        s3.put_object(Body=file_path, Bucket=bucket_name, Key=object_name)
        # s3.upload_file(file_path, bucket_name, object_name)
        # Generating the URL of the uploaded file
        file_url = f"https://pacs-dbms-neu.s3.amazonaws.com/{object_name}"
        return file_url

    except NoCredentialsError:
        print("Credentials not available")
        return None
    
    except Exception as e:
        print("Error: ", e)
        return None

if __name__ == "__main__":
    file_path = r'D:\fall23\dbms\DBMS-Final-Project\schema.png'
    bucket_name = 'pacs-dbms-neu'
    object_name = 'schema_real_1.png'

    url = upload_to_s3(file_path, bucket_name, object_name)

    if url:
        print(f"File uploaded successfully. URL: {url}")
    else:
        print("File upload failed.")