# Use an official Python runtime as a parent image
FROM python:3.6.6

# Set the working directory to /code
WORKDIR /usr/local/code

# Copy the current directory contents into the container at /code
ADD ./requirements.txt /usr/local/code

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run manage.py runserver when the container launches
CMD ["python", "src/manage.py",  "runserver", "0.0.0.0:8000"]
