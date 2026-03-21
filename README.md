# ToolSpark AI

6 AI-powered productivity tools in one Flutter mobile app.

## Tools

| # | Tool | Description |
|---|------|-------------|
| 1 | Email Writer | Craft professional emails — reply, cold outreach, follow-up, apology |
| 2 | Meeting Summarizer | Extract action items, decisions & key points from transcripts |
| 3 | Code Reviewer | AI-powered code reviews with suggestions and best practices |
| 4 | Blog Generator | SEO-optimized blog posts with custom style and keywords |
| 5 | Product Copywriter | Product descriptions for Amazon, Shopify & more |
| 6 | Tweet Threads | Engaging Twitter/X threads with custom style and tweet count |

## Screens

1. **Splash** — Animated logo with gradient background
2. **Onboarding** — 3 pages showcasing all 6 tools
3. **Home** — 2x3 tool grid with favorites
4. **Email Writer** — Type selector, tone, context input
5. **Meeting Summarizer** — Paste transcript, get structured summary
6. **Code Reviewer** — Paste code, select language, get review
7. **Blog Generator** — Topic, style, keywords, SEO output
8. **Product Copywriter** — Product details, platform selector
9. **Tweet Threads** — Topic, style, tweet count slider (5-10)
10. **Favorites & Settings** — Saved outputs, theme toggle, about

## Design

- Material 3 with indigo accent
- Dark mode default
- Each tool has its own accent color
- Smooth animations via flutter_animate

## Dependencies

- `flutter` — UI framework
- `http` — Network requests
- `shared_preferences` — Local storage
- `provider` — State management
- `google_fonts` — Typography (Inter)
- `flutter_animate` — Animations
- `share_plus` — Share content

## Getting Started

```bash
flutter pub get
flutter run
```
