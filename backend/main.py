import os
from flask import Flask, jsonify
from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.trace.samplers import ProbabilitySampler
from opencensus.trace.tracer import Tracer

# --- SRE: Observability (Application Insights) ---
# Check if the App Insights key is present
APP_INSIGHTS_KEY = os.environ.get("APP_INSIGHTS_INSTRUMENTATIONKEY")

if APP_INSIGHTS_KEY:
    # This enables distributed tracing
    exporter = AzureExporter(
        connection_string=f'InstrumentationKey={APP_INSIGHTS_KEY}'
    )
    tracer = Tracer(exporter=exporter, sampler=ProbabilitySampler(1.0))
    print("INFO: Application Insights tracing is ENABLED.")
else:
    tracer = None
    print("WARN: Application Insights tracing is DISABLED. Set APP_INSIGHTS_INSTRUMENTATIONKEY to enable.")
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