💰 Modern Expense Tracker (Dark Mode)

A clean, responsive, cross-platform mobile application designed to simplify personal finance tracking through quick manual entry and robust, visual analytics.

✨ Key Features

Real-Time Tracking: Easily add and categorize expenses/income with immediate updates to your total balance.

Visual Comparison: Provides instant insights into spending patterns with dynamically updating Doughnut and Bar Charts.

Filterable Analytics: Compare expenses across different time periods (e.g., month-over-month) using an interactive filter.

Dark Mode First: Built with a cohesive, professional dark theme featuring neon accents for excellent readability and style.

Full History View: Dedicated page for reviewing all past transactions.

💻 Tech Stack & Architecture

This project is built using the Flutter framework and leverages modern state management for a scalable structure.

Layer

Technology

Purpose

Frontend

Flutter (Dart)

Cross-platform UI development for Android and iOS.

State Management

Riverpod

Manages all transaction data and ensures reactive updates (Total Balance, Charts) across all screens.

Data Models

Dart Classes (Transaction, Category)

Structured management for all expense/income records.

Visualization

fl_chart

Used to render the dynamic Bar Charts and Doughnut Charts for data comparison.

Utility

uuid

Used for generating unique identifiers for every transaction.

🚀 Status & Roadmap

This project is currently functional for manual entry and expense comparison.

Completed Functionality:

✅ Core UI development (Home, Scan/Add, Analytics, History pages).

✅ Full Riverpod state management for transactions.

✅ Quick manual transaction entry via modal form.

✅ Real-time Total Balance and Recent Transactions display on Home screen.

✅ Dynamic Doughnut Chart display on Home screen.

Next Steps (In Progress):

Implement Time Filtering: Complete the date-filtering logic in the TransactionNotifier for the Analytics page.

Finalize Bar Chart: Integrate the live Bar Chart into the Analytics screen based on time period filtering.

Local Storage: Implement local persistence (e.g., Hive or shared preferences) to save data between sessions.

Income Tracking: Add explicit support for income transactions (currently focused on expenses).

🛠️ Getting Started

Prerequisites

Flutter SDK installed (flutter doctor is clean)

Installation

# 1. Clone the repository
git clone [YOUR-REPO-URL]
cd [YOUR-REPO-NAME]

# 2. Get dependencies (includes Riverpod and fl_chart)
flutter pub get

# 3. Run the application
flutter run
