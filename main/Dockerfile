# main/Dockerfile

FROM python:3.9-slim

WORKDIR /main

COPY . /main


RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

# Run main.py when the container launches
CMD ["streamlit", "run", "main/main.py"]