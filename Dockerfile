FROM python:3.8

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY . /code

EXPOSE 8000

RUN pip install -r requirements.txt

CMD python manage.py runserver 0.0.0.0:8000