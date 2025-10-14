#!/usr/bin/env python3
"""
Quick verification that the Chip Companion app is ready for screenshot capture.
"""

import requests
import time
from datetime import datetime

def verify_app_ready():
    """Quick verification that the app is ready."""
    print("🔍 Quick App Verification")
    print("=" * 30)
    
    base_url = "http://localhost:8080"
    
    try:
        print("Testing app connectivity...")
        response = requests.get(base_url, timeout=5)
        
        if response.status_code == 200:
            print("✅ App is running and accessible")
            print(f"🌐 URL: {base_url}")
            print(f"🕐 Checked at: {datetime.now().strftime('%H:%M:%S')}")
            
            # Check if it's a Flutter app
            if "flutter" in response.text.lower():
                print("✅ Flutter web app detected")
            else:
                print("⚠️  Flutter content not clearly detected")
            
            print("\n📱 Ready for screenshots!")
            print("Next steps:")
            print("1. Open browser to http://localhost:8080")
            print("2. Wait 15 seconds for full app load")
            print("3. Follow instructions in assets/screenshots/")
            
            return True
        else:
            print(f"❌ App returned status {response.status_code}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to app")
        print("💡 Start the Flutter server with:")
        print("   flutter run -d web-server --web-port 8080")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    verify_app_ready()
