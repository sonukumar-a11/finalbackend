FROM python:3.9.6-alpine

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Required to install post with Pip
RUN apk update && apk add bash \
  && apk add python3-dev postgresql-dev gcc musl-dev docker docker-compose

# Install pipenv
RUN pip install --upgrade pip 
RUN pip install pipenv

# Install application dependencies
COPY Pipfile Pipfile.lock requirements.txt /app/
# We use the --system flag so packages are installed into the system python
# and not into a virtualenv. Docker containers don't need virtual environments. 

RUN pip install -r requirements.txt

# Copy the application files into the image
COPY . /app/

# Expose port 8000 on the container
EXPOSE 8000
CMD ["python","./manage.py","runserver","0.0.0.0:8000"]