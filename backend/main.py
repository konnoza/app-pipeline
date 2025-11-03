import os
from flask import Flask, jsonify

# ----------------------------------------------------

app = Flask(__name__)

@app.route('/')
def home():
    """Default route."""
    return jsonify(message="Backend is healthy"), 200

@app.route('/api/data')
def get_data():
    """
    SRE: This is our Service Level Indicator (SLI) endpoint.
    We will monitor this for availability and latency.
    """
    # Use the tracer if it's enabled
    if tracer:
        with tracer.span(name='get_data_span') as span:
            data = {'service': 'backend', 'value': 123}
            return jsonify(data), 200
    else:
        data = {'service': 'backend', 'value': 123}
        return jsonify(data), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)