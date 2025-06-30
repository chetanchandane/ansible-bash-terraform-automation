from flask import Flask, request, jsonify

app = Flask(__name__)

# Simulated secret store
SECRET_STORE = {
    "db-creds": {
        "username": "devops_user",
        "password": "s3cureP@ss123"
    },
    "api-token": {
        "token": "abcd1234xyz"
    }
}

# Simple token auth
VALID_TOKENS = {"supersecrettoken123"}

@app.route('/get-secret', methods=['GET'])
def get_secret():
    api_token = request.headers.get('X-Token')
    if api_token not in VALID_TOKENS:
        return jsonify({"error": "Unauthorized"}), 401

    key = request.args.get('key')
    if key not in SECRET_STORE:
        return jsonify({"error": "Secret not found"}), 404

    return jsonify({
        "key": key,
        "secret": SECRET_STORE[key]
    })

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5050, debug=True)
