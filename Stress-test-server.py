import requests
import time
import threading
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Define the URL of your website
website_url = "https://www.yourwebsite.com"

# Define the increment step and initial user count
increment_step = 10
user_count = 0

# Define the time interval to check server responsiveness
check_interval = 60  # 1 minute

# Define the time threshold for server unresponsiveness
unresponsive_threshold = 120  # 2 minutes

# Keep track of the maximum number of users
max_users = 0

# Define a function to simulate a user visiting and scrolling
def simulate_user_traffic(user_id):
    while True:
        try:
            start_time = time.time()
            response = requests.get(website_url, verify=False)  # Disable SSL verification
            end_time = time.time()
            response_time = end_time - start_time

            # Log response time, status code, and user ID
            print(f"User {user_id}: Response Time = {response_time:.2f}s, Status Code = {response.status_code}")

            # Simulate scrolling and interaction here (e.g., scrolling, clicking links)
            time.sleep(5)
        except requests.RequestException as e:
            # Handle any potential errors here
            print(f"User {user_id}: Error - {str(e)}")
            pass

# Define a function to test the server's capacity
def test_server_capacity():
    global user_count, max_users

    while True:
        user_count += increment_step
        if user_count > max_users:
            max_users = user_count

        print(f"Testing with {user_count} users:")
        threads = []

        for user_id in range(1, user_count + 1):
            thread = threading.Thread(target=simulate_user_traffic, args=(user_id,))
            threads.append(thread)
            thread.start()

        # Sleep for the check_interval
        time.sleep(check_interval)

        # Check server responsiveness
        unresponsive_start = time.time()
        while time.time() - unresponsive_start < unresponsive_threshold:
            time.sleep(1)  # Check every second
            if check_server_responsiveness():
                break
        else:
            break

        for thread in threads:
            thread.join()

def check_server_responsiveness():
    try:
        response = requests.get(website_url, verify=False)  # Disable SSL verification
        return response.status_code == 200
    except requests.RequestException:
        return False

# Start testing server capacity
test_server_capacity()

# Print the statistics
print(f"Maximum Simultaneous Users: {max_users}")
