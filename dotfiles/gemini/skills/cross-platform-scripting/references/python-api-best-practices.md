# Python API & AI Automation Best Practices

Essential patterns for robust, secure, and performant Python scripts, specifically optimized for AI Agents and cross-platform scripting environments.

## 1. Environment & Config Management

- **Security**: NEVER hardcode credentials. Use `os.environ` or a `.env` file loader.
- **File Permissions**: Ensure configuration files containing secrets are restricted (e.g., `chmod 600 .env`) to prevent unauthorized access in multi-user environments.
- **Type-Safe Config**: Use `pydantic-settings` to validate environment variables at startup. This prevents execution if required keys are missing or malformed.
    ```python
    from pydantic_settings import BaseSettings

    class Config(BaseSettings):
        api_key: str
        model_name: str = "gpt-4o"
        
        class Config:
            env_file = ".env"
    ```

## 2. Modern HTTP Clients: Choosing the Right Tool

The choice between synchronous and asynchronous clients depends on the concurrency requirements of the automation task.

| Feature | **Requests** | **HTTPX** |
| :--- | :--- | :--- |
| **Primary Use** | Simple, synchronous scripts. | **Async AI Agents / Concurrent Tasks.** |
| **Async Support** | No (blocking). | **Native (async/await).** |
| **Best For** | One-off maintenance tasks. | High-concurrency AI/API workflows. |
| **Timeout Logic** | Basic (connect, read). | Granular (connect, read, write, pool). |


## 3. Resilience & Intelligence

- **Exponential Backoff**: Use the `tenacity` library to handle transient failures (e.g., 429 Rate Limits or 5xx Server Errors). This replaces brittle `try/except` loops with clean decorators.
    ```python
    from tenacity import retry, stop_after_attempt, wait_random_exponential

    @retry(wait=wait_random_exponential(min=1, max=60), stop=stop_after_attempt(5))
    def call_api():
        response = client.post(...)
        response.raise_for_status()
    ```
- **Circuit Breaker**: Implement logic to halt execution if an endpoint fails repeatedly. This prevents resource exhaustion and protects against permanent API bans.

## 4. Handling AI Stream Responses

Streaming is essential for reducing perceived latency and providing real-time feedback in interactive terminal environments.

- **Implementation Pattern**:
    ```python
    # Example using HTTPX for streaming
    with client.stream("POST", url, json=payload) as response:
        for chunk in response.iter_text():
            process_chunk(chunk) # Immediate processing of data chunks
    ```

## 5. Structured Data Validation

Never trust API outputs implicitly, particularly from Large Language Models (LLMs) which may return malformed or inconsistent data structures.

- **Pydantic Models**: Define the expected schema for the script's core logic (e.g., tool inputs, agent thoughts) to ensure the program doesn't crash on unexpected response keys.
- **Validation Recovery**: If data fails validation, implement a fallback mechanism or a retry loop to re-request corrected data.

## 6. Logging & Observability

In automated or headless environments, structured logging is the primary diagnostic tool for debugging script behavior.

- **Contextual Logging**: Use "Request IDs" to trace specific operations through multiple retry attempts or asynchronous tasks.
- **Log Levels**: 
    - `DEBUG`: Full payloads (ensure sensitive data is scrubbed).
    - `INFO`: Milestones and high-level logic decisions.
    - `WARNING`: Handled exceptions and slow response alerts.

## 7. Resource Management & Signal Handling

Clean resource release is mandatory to prevent system instability, memory leaks, or "device busy" errors when using hardware-bound libraries.

- **Graceful Shutdown**: Use the `signal` module to catch interruption signals (SIGINT, SIGTERM) and ensure files are closed and hardware handles are released.
    ```python
    import signal, sys

    def cleanup(sig, frame):
        print("\n[!] Releasing resources and exiting...")
        # Add logic here to close handles or stop threads
        sys.exit(0)

    signal.signal(signal.SIGINT, cleanup)  # Handle Ctrl+C
    signal.signal(signal.SIGTERM, cleanup) # Handle termination signals
    ```
