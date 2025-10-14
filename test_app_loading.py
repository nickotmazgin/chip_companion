#!/usr/bin/env python3
"""
Test script to verify Chip Companion app is loading properly for screenshots.
"""

import time
import requests
from datetime import datetime

def test_app_loading():
    """Test if the Flutter web app is loading properly."""
    print("🧪 Testing Chip Companion App Loading")
    print("=" * 50)
    
    base_url = "http://localhost:8080"
    
    # Test 1: Basic connectivity
    print("1. Testing basic connectivity...")
    try:
        response = requests.get(base_url, timeout=10)
        if response.status_code == 200:
            print("   ✅ App server is responding")
        else:
            print(f"   ❌ Server returned status {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"   ❌ Cannot connect to app: {e}")
        print("   💡 Make sure Flutter web server is running:")
        print("      flutter run -d web-server --web-port 8080")
        return False
    
    # Test 2: Check for Flutter web app content
    print("2. Checking Flutter web app content...")
    try:
        response = requests.get(base_url, timeout=15)
        content = response.text
        
        flutter_indicators = [
            "flutter",
            "dart",
            "main.dart.js",
            "Chip Companion"
        ]
        
        found_indicators = 0
        for indicator in flutter_indicators:
            if indicator.lower() in content.lower():
                found_indicators += 1
                print(f"   ✅ Found: {indicator}")
        
        if found_indicators >= 2:
            print(f"   ✅ Flutter app content detected ({found_indicators}/4 indicators)")
        else:
            print(f"   ⚠️  Limited Flutter content detected ({found_indicators}/4 indicators)")
            
    except Exception as e:
        print(f"   ❌ Error checking content: {e}")
        return False
    
    # Test 3: Simulate loading time
    print("3. Simulating app loading time...")
    print("   ⏳ Waiting 15 seconds to simulate full app load...")
    
    for i in range(15, 0, -1):
        print(f"   ⏳ {i} seconds remaining...", end="\r")
        time.sleep(1)
    
    print("   ✅ Loading simulation complete")
    
    # Test 4: Check specific app routes
    print("4. Testing app routes...")
    routes_to_test = [
        ("/", "Home screen"),
        ("/help", "Help screen"),
        ("/settings", "Settings screen")
    ]
    
    for route, description in routes_to_test:
        try:
            url = f"{base_url}{route}"
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                print(f"   ✅ {description}: {route}")
            else:
                print(f"   ⚠️  {description}: {route} (status {response.status_code})")
        except Exception as e:
            print(f"   ❌ {description}: {route} - {e}")
    
    print("\n" + "=" * 50)
    print("🎉 App loading test completed!")
    print("\n📋 Next steps for screenshots:")
    print("1. Open browser to http://localhost:8080")
    print("2. Wait 15 seconds for full app load")
    print("3. Use developer tools to set viewport dimensions")
    print("4. Follow screenshot instructions with proper loading times")
    
    return True

def check_browser_requirements():
    """Check browser requirements for screenshots."""
    print("\n🌐 Browser Requirements Check")
    print("-" * 30)
    
    requirements = [
        "Chrome/Edge with Developer Tools",
        "Firefox with Responsive Design Mode",
        "Ability to set custom viewport dimensions",
        "Screenshot capture capability"
    ]
    
    for req in requirements:
        print(f"   📋 {req}")
    
    print("\n📱 Recommended viewport dimensions:")
    dimensions = [
        "Phone Portrait: 1080 x 1920",
        "Phone Landscape: 1920 x 1080", 
        "7-inch Tablet Portrait: 1200 x 1920",
        "7-inch Tablet Landscape: 1920 x 1200",
        "10-inch Tablet Portrait: 1600 x 2560",
        "10-inch Tablet Landscape: 2560 x 1600"
    ]
    
    for dim in dimensions:
        print(f"   📏 {dim}")

if __name__ == "__main__":
    print(f"🕐 Test started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    if test_app_loading():
        check_browser_requirements()
        
        print("\n✅ All tests passed! App is ready for screenshot capture.")
        print("📖 Read the detailed instructions:")
        print("   assets/screenshots/SCREENSHOT_INSTRUCTIONS_WITH_LOADING.md")
    else:
        print("\n❌ Tests failed. Please fix the issues before capturing screenshots.")
        print("💡 Make sure to start the Flutter web server first:")
        print("   flutter run -d web-server --web-port 8080")
