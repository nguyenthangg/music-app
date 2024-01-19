import streamlit as st
import requests

def fetch_data():
    api_endpoint = "https://66wt2zswh0.execute-api.us-west-2.amazonaws.com/prod/yourlist"
    response = requests.get(api_endpoint)
    
    # Modify the video links to use the "https://www.youtube.com/embed/VIDEO_ID" format
    items = response.json().get("items", [])
    for item in items:
        item['youtubeLink'] = item['youtubeLink'].replace("https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")
    
    return items

# Fetch data when the page loads
data = fetch_data()

# Initialize session state
if 'current_video_index' not in st.session_state:
    st.session_state.current_video_index = 0

if 'is_playing' not in st.session_state:
    st.session_state.is_playing = False

# Display the Streamlit app with a two-column layout
st.title("YouTube Player and Playlist")

# Define the layout with two columns
col1, col2 = st.columns(2)

# Column 1: Display list of items with buttons to choose
with col1:
    st.header("Playlist")
    for i, item in enumerate(data):
        if st.button(f"Choose {item['name']}"):
            st.session_state.current_video_index = i
            st.session_state.is_playing = False  # Reset play state

# Column 2: Display video player and control buttons
with col2:
    st.header("Video Player")

    # Check if the current_video_index is within the valid range
    if 0 <= st.session_state.current_video_index < len(data):
        video_url = data[st.session_state.current_video_index]['youtubeLink']

        # Play, Next, and Previous buttons
        play_button = st.button("Play/Pause")
        next_button = st.button("Next Video")
        prev_button = st.button("Previous Video")

        # Handle button clicks
        if play_button:
            st.session_state.is_playing = not st.session_state.is_playing

        if next_button and st.session_state.current_video_index < len(data) - 1:
            st.session_state.current_video_index += 1
            st.session_state.is_playing = True

        if prev_button and st.session_state.current_video_index > 0:
            st.session_state.current_video_index -= 1
            st.session_state.is_playing = True

        # Display the current video index for debugging
        st.write(f"Current Video Index: {st.session_state.current_video_index}")

        # Update the video player with the new video URL and play/pause state
        st.components.v1.html(f'<iframe id="ytplayer" width="560" height="315" src="{video_url}?autoplay={int(st.session_state.is_playing)}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>', height=360, width=640)
    else:
        st.warning("Invalid video index.")
