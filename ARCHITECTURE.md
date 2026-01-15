# MindScope AI - System Architecture

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       Frontend (Streamlit)                   │
│  - Text/Image Input  - Emotion Visualizations  - Grounding  │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTP/REST
┌───────────────────────────▼─────────────────────────────────┐
│                    Flask Backend (MVC)                       │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Controllers (REST Endpoints)               │   │
│  │  - Analysis Controller  - Health Controller          │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │         LangGraph Orchestrator (Workflow)            │   │
│  │                                                       │   │
│  │  Preprocess → Emotion → Sentiment → Cognitive →      │   │
│  │  Risk → Patterns → Vision → Recommendations →        │   │
│  │  Summary → Crisis → Persistence                      │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │              AI Services Layer                       │   │
│  │                                                       │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │   │
│  │  │   Emotion    │  │  Sentiment   │  │ Cognitive │ │   │
│  │  │   Service    │  │   Service    │  │  Service  │ │   │
│  │  └──────────────┘  └──────────────┘  └───────────┘ │   │
│  │                                                       │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │   │
│  │  │     Risk     │  │   Disorder   │  │  Vision   │ │   │
│  │  │   Service    │  │   Service    │  │  Service  │ │   │
│  │  └──────────────┘  └──────────────┘  └───────────┘ │   │
│  │                                                       │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │   │
│  │  │Recommendation│  │   Summary    │  │  Crisis   │ │   │
│  │  │   Service    │  │   Service    │  │  Service  │ │   │
│  │  └──────────────┘  └──────────────┘  └───────────┘ │   │
│  └───────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐  │
│  │          Hugging Face Transformers                   │  │
│  │  - RoBERTa (Emotion)  - RoBERTa (Sentiment)          │  │
│  │  - ViT (Vision)       - Local Inference              │  │
│  └─────────────────────────────────────────────────────┘  │
└────────────────────────────┬───────────────────────────────┘
                             │
┌────────────────────────────▼───────────────────────────────┐
│                     MongoDB (NoSQL)                         │
│  Collection: analysis                                       │
│  - Emotions  - Patterns  - Risk  - Recommendations          │
└─────────────────────────────────────────────────────────────┘
```

## LangGraph Workflow (Detailed)

```python
State = {
    input_text: str,
    input_image_path: Optional[str],
    user_id: str,
    raw_emotions: List[Dict],
    sentiment_data: Dict,
    cognitive_distortions: List[Dict],
    rumination_data: Dict,
    risk_assessment: Dict,
    disorder_patterns: List[Dict],
    vision_analysis: Optional[Dict],
    recommendations: List[Dict],
    grounding_techniques: List[Dict],
    psychological_summary: Dict,
    crisis_resources: Dict,
    analysis_result: Optional[AnalysisResult],
    timestamp: datetime
}

Workflow:
    1. preprocess_node(state) → add timestamp
    2. emotion_node(state) → HF emotion model → raw_emotions
    3. sentiment_node(state) → HF sentiment model → sentiment_data
    4. cognitive_node(state) → regex + patterns → cognitive_distortions + rumination
    5. risk_node(state) → risk patterns + emotion alignment → risk_assessment
    6. pattern_node(state) → disorder indicators → disorder_patterns
    7. vision_node(state) → ViT model (if image) → vision_analysis
    8. recommendation_node(state) → book/routine database → recommendations + grounding
    9. summary_node(state) → aggregate all → psychological_summary
    10. crisis_node(state) → risk-based → crisis_resources
    11. persistence_node(state) → MongoDB insert → analysis_result with ID
```

## Data Flow

### Text Analysis Flow
```
User Text Input
    ↓
Flask Controller
    ↓
Orchestrator.analyze_text()
    ↓
LangGraph Workflow Execution
    ↓
[Parallel AI Service Calls]
    ├─ Emotion Analysis (HF Transformers)
    ├─ Sentiment Analysis (HF Transformers)
    ├─ Cognitive Distortion (Regex + Pattern Matching)
    ├─ Risk Assessment (Rule-based + ML scores)
    └─ Disorder Pattern Detection (Hybrid)
    ↓
[Sequential Processing]
    ├─ Recommendation Engine (Knowledge Base)
    ├─ Summary Generation (Aggregation)
    └─ Crisis Resources (Conditional)
    ↓
MongoDB Persistence
    ↓
Return AnalysisResult
    ↓
JSON Response to Frontend
    ↓
Streamlit Visualization
```

### Image Analysis Flow
```
User Image Upload
    ↓
Flask Controller (file handling)
    ↓
Temp File Storage
    ↓
Orchestrator.analyze_image()
    ↓
LangGraph Vision Node
    ↓
ViT Image Classification (HF)
    ↓
Psychological Interpretation
    ├─ Emotion extraction from labels
    ├─ Scene interpretation
    ├─ Distress indicator detection
    └─ Symbolic cue analysis
    ↓
[Continue Standard Workflow]
    ↓
MongoDB Persistence
    ↓
Cleanup Temp File
    ↓
JSON Response
```

## Service Layer Architecture

### EmotionAnalysisService
- **Model**: `j-hartmann/emotion-english-distilroberta-base`
- **Input**: Text (truncated to 512 tokens)
- **Output**: Top 7 emotions with scores, intensity, explanations
- **Method**: Zero-shot classification via HF pipeline

### SentimentAnalysisService
- **Model**: `cardiffnlp/twitter-roberta-base-sentiment-latest`
- **Input**: Text (truncated to 512 tokens)
- **Output**: Positive/negative/neutral scores, intensity (0-100), stress level
- **Method**: Multi-label classification

### CognitiveDistortionService
- **Method**: Regex pattern matching + keyword scoring
- **Patterns**: 10 CBT distortion types (all-or-nothing, catastrophizing, etc.)
- **Output**: Distortions with confidence scores and reframe suggestions
- **Bonus**: Rumination loop detection

### RiskAssessmentService
- **Method**: Hybrid (keyword matching + emotion integration + protective factors)
- **Risk Levels**: minimal, low, moderate, elevated
- **Output**: Graded risk score, indicators, protective factors, recommended actions
- **Safety**: Non-alarmist language, always provides support resources

### DisorderPatternService
- **Method**: Linguistic pattern matching + emotion alignment
- **Patterns**: Anxiety, depression, OCD, PTSD, bipolar, dissociation, ADHD, eating disorders
- **Output**: Top 5 patterns with confidence, indicators, explanations
- **Note**: Explicitly states "not a diagnosis"

### VisionAnalysisService
- **Model**: `google/vit-base-patch16-224`
- **Input**: Image (PIL format)
- **Output**: Detected emotions, facial expression, scene interpretation, symbolic cues, distress indicators
- **Method**: Image classification → psychological mapping

### RecommendationService
- **Database**: Curated books (30+ titles) and routines (5+ protocols)
- **Logic**: Pattern-based matching (anxiety → anxiety books)
- **Output**: Books with author/tone/reasoning, routines with steps

### SummaryService
- **Method**: Aggregation of all analysis outputs
- **Output**: Primary emotions, emotional state, cognitive patterns, stress level, description, key insights
- **Purpose**: Human-readable synthesis

### CrisisResourceService
- **Database**: International mental health hotlines (US, UK, Canada, Australia, Europe)
- **Logic**: Conditional display based on risk level (elevated/moderate)
- **Tone**: Non-alarmist, supportive, empowering

## Database Schema (MongoDB)

```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439011"),

  // Input
  user_id: "user123",
  input_text: "I feel anxious...",
  input_image_metadata: {
    path: "/tmp/image.jpg",
    uploaded_at: ISODate("2024-01-15T10:30:00Z")
  },

  // Emotion Analysis
  emotions: [
    {
      emotion: "fear",
      score: 0.85,
      intensity: "strong",
      explanation: "Fear is clearly present..."
    }
  ],
  sentiment_intensity: 28.5,

  // Cognitive Analysis
  cognitive_distortions: [
    {
      distortion_type: "Catastrophizing",
      confidence: 0.75,
      evidence: "Detected: 'disaster'",
      reframe_suggestion: "What is the most realistic outcome?"
    }
  ],

  // Risk Assessment
  risk_assessment: {
    overall_risk_level: "moderate",
    risk_score: 0.45,
    self_harm_indicators: ["hopelessness"],
    protective_factors: ["support system"],
    explanation: "Some concerning patterns...",
    recommended_action: "Consider professional support..."
  },

  // Disorder Patterns
  disorder_patterns: [
    {
      pattern_name: "Anxiety Patterns",
      confidence: 0.8,
      indicators: ["worry", "can't stop thinking"],
      explanation: "Language suggests persistent worry..."
    }
  ],

  // Vision Analysis (if image)
  vision_analysis: {
    detected_emotions: ["sadness", "fear"],
    facial_expression: "person looking sad",
    scene_interpretation: "low-light environment",
    symbolic_cues: ["isolation", "darkness"],
    distress_indicators: ["darkness may indicate low mood"],
    psychological_interpretation: "Visual analysis suggests..."
  },

  // Recommendations
  recommendations: [
    {
      recommendation_type: "book",
      title: "Feeling Good by David Burns",
      description: "Reading tone: gentle and encouraging",
      why_helpful: "Classic CBT approach...",
      target_pattern: "cognitive distortions"
    }
  ],

  grounding_techniques: [
    {
      technique_name: "5-4-3-2-1 Grounding",
      description: "Sensory grounding...",
      steps: ["Name 5 things you can see", ...],
      when_to_use: "Panic, anxiety, dissociation"
    }
  ],

  // Psychological Summary
  psychological_summary: {
    primary_emotions: ["fear", "sadness"],
    emotional_state: "distressed",
    cognitive_patterns: ["Catastrophizing"],
    stress_level: "moderate",
    mental_state_description: "You appear to be experiencing...",
    key_insights: [
      "Fear is strongly present...",
      "Catastrophizing detected..."
    ]
  },

  // Metadata
  created_at: ISODate("2024-01-15T10:30:00Z"),
  updated_at: ISODate("2024-01-15T10:30:05Z")
}
```

## Frontend Architecture (Streamlit)

### Component Hierarchy
```
MindScopeUI (Main Class)
│
├── render_header()
│   └── Title + Subtitle
│
├── render_sidebar()
│   ├── About section
│   ├── Clear analysis button
│   └── Breathing exercise
│
├── render_input_section()
│   ├── Input type selector (Text/Image/Both)
│   ├── Text area
│   ├── Image uploader
│   └── Analyze button → perform_analysis()
│
└── render_results()
    ├── render_summary()
    ├── render_emotions() → Plotly bar chart
    ├── render_cognitive_distortions()
    ├── render_risk_assessment()
    ├── render_disorder_patterns()
    ├── render_vision_analysis()
    ├── render_grounding_techniques()
    ├── render_recommendations()
    └── render_crisis_resources()
```

### Visualization Strategy
- **Emotion Bar Chart**: Horizontal bars with color gradient (Plotly)
- **Risk Indicators**: Color-coded badges (minimal=green, elevated=red)
- **Grounding Techniques**: Purple gradient boxes with step-by-step lists
- **Crisis Resources**: Warm orange box (non-alarmist)
- **Color Palette**: Soft blues, purples, warm grays (calming)

## AI Model Selection Rationale

| Requirement | Model Choice | Reasoning |
|-------------|-------------|-----------|
| Emotion Detection | `emotion-english-distilroberta-base` | Fine-tuned on 7 emotions, balanced accuracy/speed |
| Sentiment Analysis | `twitter-roberta-base-sentiment-latest` | Robust to informal text, multi-class |
| Vision Analysis | `vit-base-patch16-224` | General-purpose image classification, interpretable |

## Performance Optimization

### Model Loading
- **Singleton Pattern**: Services instantiate models once at startup
- **Lazy Loading**: Models load on first request (optional)
- **GPU Acceleration**: Automatic CUDA detection

### Inference Optimization
- **Batch Size**: 1 (real-time analysis)
- **Text Truncation**: 512 tokens (RoBERTa max)
- **Model Quantization**: Optional (reduce memory)

### Database Optimization
- **Indexes**: `user_id`, `created_at` (for history queries)
- **Connection Pooling**: MongoDB driver handles automatically
- **Document Size**: ~5-15KB per analysis (efficient)

## Scalability Considerations

### Current Limitations
- Single-threaded Flask (dev server)
- CPU inference (2-5s per request)
- Local file storage (images)

### Production Recommendations
1. **Backend**: Gunicorn + Nginx (multi-worker)
2. **AI**: GPU instances or model quantization
3. **Database**: MongoDB Atlas (managed, replica set)
4. **Storage**: S3/Cloud Storage for images
5. **Caching**: Redis for frequently accessed analyses
6. **Load Balancing**: Multiple backend instances

## Security & Privacy

### Current Implementation
- **No User Authentication**: Anonymous by design
- **No PII Storage**: User IDs are strings (not tied to identity)
- **Local Processing**: All AI runs locally (no external API calls)
- **Temporary Files**: Images deleted immediately after processing

### Production Hardening
1. **HTTPS**: SSL/TLS encryption
2. **Input Validation**: Sanitize text, validate image types
3. **Rate Limiting**: Prevent abuse
4. **Encryption at Rest**: MongoDB encryption
5. **Audit Logs**: Track access patterns

## Testing Strategy

### Unit Tests
- **Services**: Mock HF pipelines, test pattern detection logic
- **Controllers**: Mock orchestrator, test endpoints
- **Database**: Mock MongoDB client

### Integration Tests
- **LangGraph Workflow**: Test full pipeline with real state
- **API Endpoints**: Test request/response cycle

### Future: E2E Tests
- **Streamlit UI**: Selenium/Playwright tests
- **Full User Journey**: Input → Analysis → Display

---

**Architecture Philosophy**: Explainability, modularity, and human-centered design. Every component produces interpretable outputs, enabling debugging and user trust.
