# Zecure: Real-Time Intrusion Detection and Prevention System

A final-year team project that detects network attacks in real time and blocks the attacker automatically. This repository contains the Flutter mobile app of the project.

## About the project
Traditional security tools rely on known attack signatures and often miss new threats. Zecure uses a Convolutional Neural Network (CNN) trained on the NSL-KDD dataset to classify network traffic as normal or malicious. Live packets are captured with Scapy and Npcap, and when an attack is detected, the source IP is blocked with a firewall rule.

## How the system works
1. Data preprocessing: load and clean NSL-KDD, encode categories, normalize values
2. Model training: CNN for multi-class classification of normal and attack traffic
3. Real-time packet capture: Scapy with Npcap
4. Prediction: classify each packet's features with the trained model
5. Prevention: block the attacker's IP through the OS firewall
6. Logging and alerts: record detected threats and show alerts

## App features
- User registration and login
- Profile viewing and editing, change and forgot password
- Sending complaints and reviews, and viewing replies
- Chat and expert contact
- Viewing logs and request status

## Tech used
- Flutter and Dart (mobile app)
- Python, CNN, Scapy and Npcap (detection engine)
- NSL-KDD dataset
- MySQL

## Note
This was a team project developed during my BSc Computer Science degree at MAMO College, University of Calicut.
