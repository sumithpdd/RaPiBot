# DevFest London 2025 Photo Booth - Interactive Features

## 🎉 Welcome Experience

### Initial Greeting (Auto-play)
```
App loads → Wait 3 seconds →
🗣️ "Welcome to DevFest London 2025! I am your photo booth assistant!"
→ Wait 6 seconds →
🗣️ "Say take a photo when you are ready, or start photo session for timed fun!"
```

---

## 📸 Photo Booth Commands

### Instant Photo Commands

**"Take a photo"** / **"Snap a picture"** / **"Capture a selfie"**
```
🗣️ Response: "Perfect! Get ready to smile! Photo in 3... 2... 1... Say cheese!"
```

**"Ready for photo"** / **"Prepared for picture"**
```
🗣️ Response: "Great! Let me get you set up! Say take a photo when you are ready!"
```

**"Use photobooth"** / **"Try the photo booth"**
```
🗣️ Response: "Welcome to our interactive photo booth at DevFest London 2025! 
             Just say take a photo or start photo session and I will help you!"
```

### Photo Session Commands

**"Start photo session for 5 minutes"**
```
🗣️ Response: "Awesome! Starting your 5 minute photo session at DevFest London! 
             Strike your best pose!"
```

**"Start photo session for 10 minutes"**
```
🗣️ Response: "Awesome! Starting your 10 minute photo session at DevFest London! 
             Strike your best pose!"
```

### Help Commands

**"How does it work"** / **"How to use"**
```
🗣️ Response: "It is super easy! Just say take a photo for instant fun, 
             or start photo session to set a timer. I am here to help you 
             capture amazing moments at DevFest London!"
```

**"What's happening"** / **"What can you do"**
```
🗣️ Response: "Welcome to DevFest London 2025 photo booth! Ready to take amazing photos!"
```

**"Show calendar"** / **"Display schedule"**
```
🗣️ Response: "Photo booth is ready at DevFest London 2025! Strike a pose!"
```

### Timer Commands

**"Start pomodoro for 25 minutes"**
```
🗣️ Response: "Starting 25 minute photo countdown! Get ready!"
```

**"Set timer for 10 minutes"**
```
🗣️ Response: "Photo timer set for 10 minutes. Smile!"
```

**"Cancel timer"** / **"Stop session"**
```
🗣️ Response: "Photo timer cancelled"
```

---

## 🎭 Interactive Journey

### First-Time User Flow

```
User arrives at booth
    ↓
🗣️ "Welcome to DevFest London 2025! I am your photo booth assistant!"
    ↓
User listens
    ↓
🗣️ "Say take a photo when you are ready, or start photo session for timed fun!"
    ↓
User: "How does it work?"
    ↓
🗣️ "It is super easy! Just say take a photo for instant fun, 
    or start photo session to set a timer. I am here to help you 
    capture amazing moments at DevFest London!"
    ↓
User: "Take a photo"
    ↓
🗣️ "Perfect! Get ready to smile! Photo in 3... 2... 1... Say cheese!"
    ↓
📸 PHOTO TAKEN!
```

### Group Photo Session Flow

```
Group arrives
    ↓
User: "Start photo session for 10 minutes"
    ↓
🗣️ "Awesome! Starting your 10 minute photo session at DevFest London! 
    Strike your best pose!"
    ↓
⏱️ Timer: 10:00 countdown
    ↓
Group takes multiple photos
    ↓
User: "What's happening?"
    ↓
🗣️ "Photo countdown: 10 minutes and 0 seconds. Get ready for your picture!"
    ↓
Timer ends
    ↓
Session complete!
```

### Hesitant User Flow

```
User: "Use photobooth"
    ↓
🗣️ "Welcome to our interactive photo booth at DevFest London 2025! 
    Just say take a photo or start photo session and I will help you!"
    ↓
User: "Ready for photo"
    ↓
🗣️ "Great! Let me get you set up! Say take a photo when you are ready!"
    ↓
User gains confidence
    ↓
User: "Take a photo"
    ↓
🗣️ "Perfect! Get ready to smile! Photo in 3... 2... 1... Say cheese!"
```

---

## 🎤 Voice Interaction Features

### Speaking Animation Priority
- **Highest Priority** - Speaking always triggers `speaking.mp4`
- **Instant Switch** - No delay when voice starts
- **Protected** - Sensors can't interrupt speaking
- **Smooth Return** - Returns to ambient video after speaking

### Listening Indicators
- **Visual Feedback** - "Listening..." indicator when mic active
- **Subtitle Display** - Shows what AI is saying in real-time
- **Status Updates** - Clear state transitions

### Timing & Delays
- **Welcome Message**: 3 seconds after app load
- **Second Message**: 6 seconds after first
- **Video Cooldown**: 10 seconds between changes
- **Sensor Updates**: Every 15 seconds
- **Speaking Duration**: 3-15 seconds (based on text length)

---

## 🎨 Visual States

### Ambient States (When Idle)

| Video | Trigger | Meaning |
|-------|---------|---------|
| 🔵 `blink.mp4` | CO2 normal (< 500 ppm) | **Ready for photos!** |
| 🟡 `yellow.mp4` | CO2 warning (500-750 ppm) | **Environment warming** |
| 🔴 `red.mp4` | CO2 alert (750-1500 ppm) | **Take a break soon** |
| ⚫ `black.mp4` | Low light (< 10) | **Dark mode** |

### Active States

| Video | Trigger | Meaning |
|-------|---------|---------|
| 🗣️ `speaking.mp4` | AI Assistant speaking | **Listen to instructions** |
| ⏱️ Timer Display | Session running | **Photo countdown active** |
| 📢 Notification | Alert/Meeting | **Important message** |

---

## 🎮 Mock Voice Panel

### Quick Commands Tab

```
📸 Photo Commands:
   • "take a photo" - Instant photo
   • "ready for photo" - Get ready message
   • "use photobooth" - Learn about booth

📅 Session Commands:
   • "start photo session for 5 minutes"
   • "start photo session for 10 minutes"

⏱️ Timer Commands:
   • "start pomodoro for 25 minutes"
   • "set timer for 10 minutes"
   • "cancel timer"

❓ Help Commands:
   • "how does it work" - Instructions
   • "what's happening" - Current status
   • "show calendar" - Ready message
```

### Use Cases Tab

**1. Quick Photo**
- Take instant photo without timer

**2. Photo Session (5 min)**
- Start quick session for individual

**3. Photo Session (10 min)**
- Start session for group photos

**4. Learn How**
- Get instructions on using booth

**5. Status Check**
- Check current photo booth status

---

## 🌟 Key Differences from Pomodoro Bot

| Aspect | Pomodoro Bot | Photo Booth |
|--------|--------------|-------------|
| **Welcome** | Silent start | Two-part greeting + instructions |
| **Focus** | Timer management | Photo experience |
| **Commands** | Work-focused | Fun, event-focused |
| **Tone** | Productive | Exciting, welcoming |
| **Interactions** | Minimal | Continuous engagement |
| **Purpose** | Focus sessions | Capture memories |
| **Voice** | Helper | Enthusiastic guide |

---

## 📊 User Engagement Flow

```
┌─────────────────────────────────────────────────┐
│           App Loads & Welcomes                  │
│   "Welcome to DevFest London 2025!"             │
└──────────────────┬──────────────────────────────┘
                   │
         User explores voice commands
                   │
┌──────────────────▼──────────────────────────────┐
│         Multiple Interaction Points              │
│  • Take photo                                    │
│  • Start session                                 │
│  • Ask questions                                 │
│  • Get help                                      │
└──────────────────┬──────────────────────────────┘
                   │
         Continuous assistance
                   │
┌──────────────────▼──────────────────────────────┐
│          Photo Booth Experience                  │
│  • Countdown animations                          │
│  • Voice feedback                                │
│  • Status updates                                │
│  • Friendly prompts                              │
└──────────────────────────────────────────────────┘
```

---

## 🎯 Success Metrics

**Engagement Indicators:**
- ✅ Users hear welcome message (100% exposure)
- ✅ Multiple command options available
- ✅ Friendly, encouraging tone throughout
- ✅ Clear instructions for new users
- ✅ Quick photo option for immediate fun
- ✅ Timer option for planned sessions
- ✅ Help always available

**User Journey Success:**
- First-time users understand how to use booth
- Groups can start timed sessions easily
- Instant photos available for quick fun
- Help and instructions readily available
- Enthusiastic, event-appropriate tone

---

## 🚀 Ready for DevFest London 2025!

**The photo booth now provides:**
1. ✅ Warm, welcoming greeting
2. ✅ Clear instructions
3. ✅ Multiple interaction paths
4. ✅ Photo-focused experience
5. ✅ Continuous voice engagement
6. ✅ Helpful, friendly assistant
7. ✅ Fun, event-appropriate tone
8. ✅ Easy for first-time users
9. ✅ Professional yet playful
10. ✅ Memorable DevFest experience!

**Try it now:** http://localhost:8080

Click the orange panel and say: **"take a photo"** or **"use photobooth"**! 📸✨

