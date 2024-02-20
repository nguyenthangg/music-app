import streamlit as st
import requests
import json

# Function to extract YouTube video ID from URL
def get_video_id(url):
    if "youtube.com" in url or "youtu.be" in url:
        video_id = url.split("v=")[-1]
        if "&" in video_id:
            video_id = video_id.split("&")[0]
        return video_id
    return None

# Function to create modified YouTube URL
def create_modified_url(video_id):
    base_url = f'https://www.youtube.com/embed/{video_id}'
    return base_url








# Streamlit app
st.title("YouTube URL Processor")

# Input for JSON data
json_input = st.text_area("Enter link data (in the format provided):", '{"id": 1, "youtubeLink": "https://www.youtube.com/watch?v=Ve_1XZkG65U"}')

# Process input when JSON data is provided
if st.button("Process JSON"):
    try:
        input_data = json.loads(json_input)
    except json.JSONDecodeError:
        st.error("Invalid JSON format. Please provide valid JSON data.")
        st.stop()

    video_url = input_data.get("youtubeLink")
    video_id = get_video_id(video_url)

    if video_id:
        modified_url = create_modified_url(video_id)
        st.text(f"Modified YouTube URL: {modified_url}")

        # Example: Sending the modified URL to an API (replace the API endpoint with your actual API endpoint)
        api_endpoint = "https://66wt2zswh0.execute-api.us-west-2.amazonaws.com/prod/yourlist"
        payload = {
            "id": input_data.get("id"),
            "youtubeLink": modified_url
        }
        headers = {"Content-Type": "application/json"}

        response = requests.post(api_endpoint, json=payload, headers=headers)

        # Display API response
        if response.status_code == 200:
            st.success(f"API Response: {response.json()}")
        else:
            st.error(f"API Request Failed. Status Code: {response.status_code}")
    else:
        st.error("Invalid YouTube URL. Please provide a valid YouTube video URL.")
