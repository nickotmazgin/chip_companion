#!/bin/bash
# Quick start script for Chip Companion screenshot generation

echo "🎯 Chip Companion - Screenshot Generation Quick Start"
echo "=================================================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Please run this script from the Chip Companion project root directory"
    exit 1
fi

echo "✅ Flutter found"
echo "✅ Project directory confirmed"

# Kill any existing Flutter processes
echo "🔄 Stopping any existing Flutter processes..."
pkill -f "flutter" 2>/dev/null || true
sleep 2

# Start Flutter web server
echo "🚀 Starting Flutter web server on port 8080..."
flutter run -d web-server --web-port 8080 &
FLUTTER_PID=$!

# Wait for server to start
echo "⏳ Waiting for server to start..."
sleep 10

# Check if server is running
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ Flutter web server started successfully!"
    echo ""
    echo "🌐 App is available at: http://localhost:8080"
    echo ""
    echo "📖 Next steps:"
    echo "1. Open your browser to http://localhost:8080"
    echo "2. Read the instructions: assets/screenshots/SCREENSHOT_INSTRUCTIONS.md"
    echo "3. Use browser developer tools to set viewport dimensions"
    echo "4. Capture screenshots following the guide"
    echo ""
    echo "📱 Recommended viewport dimensions:"
    echo "   Phone Portrait: 1080 x 1920"
    echo "   Phone Landscape: 1920 x 1080"
    echo "   7-inch Tablet Portrait: 1200 x 1920"
    echo "   7-inch Tablet Landscape: 1920 x 1200"
    echo "   10-inch Tablet Portrait: 1600 x 2560"
    echo "   10-inch Tablet Landscape: 2560 x 1600"
    echo ""
    echo "🛑 To stop the server, press Ctrl+C"
    
    # Try to open browser (optional)
    if command -v xdg-open &> /dev/null; then
        echo "🌐 Opening browser..."
        xdg-open http://localhost:8080 &
    elif command -v open &> /dev/null; then
        echo "🌐 Opening browser..."
        open http://localhost:8080 &
    fi
    
    # Wait for user to stop
    wait $FLUTTER_PID
else
    echo "❌ Failed to start Flutter web server"
    echo "Please check for errors above and try again"
    exit 1
fi
