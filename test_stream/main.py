# streamlit_app.py
import base64
import streamlit as st
import requests

def main():
    st.title("Streamlit Multipage App")

    page = st.sidebar.selectbox("Select a page", ["Home", "Data"])

    if page == "Home":
        st.write("Welcome to the home page!")

    elif page == "Data":
        
        if authenticate() == 200:
            st.write("Data page")
            response = fetch_data()
            st.write(response.json())

def authenticate():
    username = st.text_input("Username:")
    password = st.text_input("Password:", type="password")
    credentials = base64.b64encode(f'{username}:{password}'.encode('utf-8')).decode('utf-8')
    if st.button("Authenticate"):
        headers = {'Authorization': f'Basic {credentials}'}
        print(headers)
        response = requests.get('https://66wt2zswh0.execute-api.us-west-2.amazonaws.com/prod/health', headers=headers)

        if response.status_code == 200:
            st.success("Authentication successful!")
        else:
            st.error("Authentication failed. Please check your credentials.")

def fetch_data():
    # Implement Proxy-Authenticate logic if needed
    # e.g., using requests library with custom headers
    response = requests.get('http://localhost:5000/api/data')
    return response

if __name__ == "__main__":
    main()
