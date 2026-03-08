#!/usr/bin/env python3
"""
Python API Automation Template
Use this template as a starting point for robust API interaction scripts.

Features:
- Environment variable loading (.env support)
- Command-line argument parsing (argparse)
- Structured logging
- Robust HTTP requests with retries and timeouts
- Error handling
"""

import os
import sys
import argparse
import logging
import time
from typing import Dict, Any, Optional

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from dotenv import load_dotenv

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
logger = logging.getLogger(__name__)

# Constants
DEFAULT_TIMEOUT = (3.05, 27)  # (connect, read)
MAX_RETRIES = 3
BACKOFF_FACTOR = 1
RETRY_STATUS_CODES = [429, 500, 502, 503, 504]


def create_session() -> requests.Session:
    """Creates a requests.Session with retry logic configured."""
    session = requests.Session()
    retry_strategy = Retry(
        total=MAX_RETRIES,
        backoff_factor=BACKOFF_FACTOR,
        status_forcelist=RETRY_STATUS_CODES,
        allowed_methods=["HEAD", "GET", "OPTIONS", "POST", "PUT", "DELETE"]
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session.mount("https://", adapter)
    session.mount("http://", adapter)
    return session


def fetch_data(session: requests.Session, url: str, params: Optional[Dict] = None) -> Optional[Dict[str, Any]]:
    """
    Fetches JSON data from the given URL.

    Args:
        session: The active requests.Session.
        url: The target URL.
        params: Optional query parameters.

    Returns:
        The JSON response as a dictionary, or None on failure.
    """
    try:
        logger.info(f"Fetching data from: {url}")
        response = session.get(url, params=params, timeout=DEFAULT_TIMEOUT)
        response.raise_for_status()  # Raise HTTPError for bad responses (4xx, 5xx)
        
        # Log rate limit info if available (example header names)
        remaining = response.headers.get("X-RateLimit-Remaining")
        if remaining:
             logger.debug(f"Rate limit remaining: {remaining}")

        return response.json()

    except requests.exceptions.HTTPError as err:
        logger.error(f"HTTP Error: {err}")
        if err.response.status_code == 429: # Too Many Requests
             retry_after = err.response.headers.get("Retry-After")
             logger.warning(f"Rate limited. Retry after: {retry_after}s")
    except requests.exceptions.ConnectionError as err:
        logger.error(f"Connection Error: {err}")
    except requests.exceptions.Timeout as err:
        logger.error(f"Timeout Error: {err}")
    except requests.exceptions.RequestException as err:
        logger.error(f"Request Exception: {err}")
    except ValueError as err: # JSON Decode Error
        logger.error(f"JSON Decode Error: {err}")
    
    return None


def main():
    """Main execution entry point."""
    # Load environment variables from .env file
    load_dotenv()

    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="API Automation Script Template")
    parser.add_argument("--url", help="Target API URL", required=True)
    parser.add_argument("--key", help="API Key (can also be set via API_KEY env var)")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging")
    args = parser.parse_args()

    # Configure verbosity
    if args.verbose:
        logger.setLevel(logging.DEBUG)

    # Get API Key (Order: Arg > Env Var)
    api_key = args.key or os.getenv("API_KEY")
    if not api_key:
        logger.warning("No API Key provided. Continuing without authentication (may fail).")

    # Example: Execute Request
    session = create_session()
    
    # Headers example
    if api_key:
        session.headers.update({"Authorization": f"Bearer {api_key}"})

    data = fetch_data(session, args.url)

    if data:
        logger.info("Successfully retrieved data.")
        # Process data here
        logger.debug(f"Data: {data}")
    else:
        logger.error("Failed to retrieve data.")
        sys.exit(1)


if __name__ == "__main__":
    main()
