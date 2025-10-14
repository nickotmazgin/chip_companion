APP_URL?=http://localhost:8080
# Default device pixel ratio for manual previews (override on invocation)
# Phone typical DPR ~3, tablets ~2
DPR?=1

# Helpers
open = bash tools/open_preset.sh

## Phone (9:16 and 16:9)
phone-portrait: ## 1080x1920 / (pass DPR=3 for realistic phone density)
	$(open) 1080 1920 / $(DPR)

phone-landscape: ## 1920x1080 / (pass DPR=3 for realistic phone density)
	$(open) 1920 1080 / $(DPR)

## Tablet 7"
tablet7-portrait: ## 1200x1920 / (pass DPR=2 for realistic tablet density)
	$(open) 1200 1920 / $(DPR)

tablet7-landscape: ## 1920x1200 / (pass DPR=2 for realistic tablet density)
	$(open) 1920 1200 / $(DPR)

## Tablet 10"
tablet10-portrait: ## 1600x2560 / (pass DPR=2 for realistic tablet density)
	$(open) 1600 2560 / $(DPR)

tablet10-landscape: ## 2560x1600 / (pass DPR=2 for realistic tablet density)
	$(open) 2560 1600 / $(DPR)

## Common alternate routes
phone-glossary: ## 1080x1920 /glossary (pass DPR=3)
	$(open) 1080 1920 /glossary $(DPR)

phone-support: ## 1080x1920 /support (pass DPR=3)
	$(open) 1080 1920 /support $(DPR)

# --- Automation: DPR-aware screenshot generator shortcuts ---
PY?=python3
GEN=tools/working_screenshot_generator.py

# Phone/tablet helpers use sensible DPR defaults; override with DPR=...
gen-phone-portrait: ## Generate phone portrait screenshots (DPR=3 recommended)
	$(PY) $(GEN) --device-type phone --orientation portrait --dpr $(DPR)

gen-phone-landscape: ## Generate phone landscape screenshots (DPR=3 recommended)
	$(PY) $(GEN) --device-type phone --orientation landscape --dpr $(DPR)

gen-tablet7-portrait: ## Generate 7" tablet portrait (DPR=2 recommended)
	$(PY) $(GEN) --device-type tablet7 --orientation portrait --dpr $(DPR)

gen-tablet7-landscape: ## Generate 7" tablet landscape (DPR=2 recommended)
	$(PY) $(GEN) --device-type tablet7 --orientation landscape --dpr $(DPR)

gen-tablet10-portrait: ## Generate 10" tablet portrait (DPR=2 recommended)
	$(PY) $(GEN) --device-type tablet10 --orientation portrait --dpr $(DPR)

gen-tablet10-landscape: ## Generate 10" tablet landscape (DPR=2 recommended)
	$(PY) $(GEN) --device-type tablet10 --orientation landscape --dpr $(DPR)

.PHONY: phone-portrait phone-landscape tablet7-portrait tablet7-landscape \
	tablet10-portrait tablet10-landscape phone-glossary phone-support \
	gen-phone-portrait gen-phone-landscape gen-tablet7-portrait \
	gen-tablet7-landscape gen-tablet10-portrait gen-tablet10-landscape
