# Defensive Security Controls for OpenClaw AI Agents

## Project Domain
AI Agent Security (Option 3)

## Team Members
* Elbert Henriquez: Technical Implementation and Validation Lead
* Esteban Calderon: Documentation and Presentation Co-Lead
* Gavin Barton: Project Lead
* Opjeet Dhanoa: Risk/Threat Analyst
* Berenice Moreno-Perez: Documentation and Presentation Co-Lead


## Project Description
This project evaluates the security posture of OpenClaw, an open-source AI agent framework that connects LLMs to real-world tools, file systems, and messaging platforms. Acting as a defensive security team for an organization considering OpenClaw for internal deployment, we audit the agent's default configuration, identify security gaps, and implement defensive controls to reduce risk.
The focus areas include least-privilege tool permissions, skill vetting and sandboxing, structured audit logging, input validation against prompt injection, and human-in-the-loop gates for sensitive actions.

## Tools Used
OpenClaw — Open-source AI agent framework (subject of analysis)
Google AI Studio (Gemini 2.5 Flash) — Primary LLM backend (free tier)
Ollama — Local LLM backend for testing data exfiltration controls
Docker — Agent isolation and lab environment
Git/GitHub — Version control and project delivery
