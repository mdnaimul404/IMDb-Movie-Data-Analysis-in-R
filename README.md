# 🎬 IMDb Movie Data Analysis (Academic-Project)

## 🧑‍💻 Course Information
**Course:**  Data Science  
**Semester:** Fall 2025  
**Institution:** American International University–Bangladesh (AIUB)  
**Project Type:** Group Project  

---

## 👥 Group Members

| Name | Student ID |
|------|-------------|
| **Abdullah Adnan Abul Kalam** | 22-47846-2 |
| **Md. Naimul Islam** | 22-47899-2 |
| **Md. Nafis Islam** | 22-47908-2 |
| **Md. Abu Jar Gifari** | 22-47917-2 |

---

## 📘 Project Overview
This project focuses on performing **Exploratory Data Analysis (EDA)** on the IMDb 5000 Movie Dataset using **R**.  
The objective is to clean, transform, summarize, and visualize movie data to uncover insights on ratings, budgets, revenues, genres, and production patterns over time.

The analysis aims to answer key questions such as:
- What factors influence IMDb ratings?
- Do higher budgets always mean higher profits?
- Which genres tend to have higher ROI?
- How have movie trends evolved across decades?

---

## 🧰 Technologies Used
- **Programming Language:** R  
- **Core Packages:** `readr`, `dplyr`, `ggplot2`, `stringr`, `tidyr`, `tibble`  
- **Dataset Source:** [IMDb 5000+ Movie Dataset](https://raw.githubusercontent.com/Nafis-Rohan/imdb-5000-data/refs/heads/main/movie_metadata.csv)

---

## 🧪 Project Workflow

### 1️⃣ Package Installation and Loading
The script automatically installs and loads all necessary R packages before analysis begins.

### 2️⃣ Data Import and Overview
- Reads movie data directly from the IMDb dataset URL.
- Displays initial structure, summary statistics, and column types.
- Reports the total number of rows and columns.

### 3️⃣ Data Cleaning and Preprocessing
Steps include:
- Trimming whitespace from movie titles.  
- Converting **budget** and **gross** to millions.  
- Extracting **primary genre** from multi-genre strings.  
- Handling missing and zero values using median imputation.  
- Removing duplicate entries.  
- Creating new derived columns:
  - `budget_million`
  - `gross_million`
  - `roi_imp` → Return on Investment
  - `decade` → e.g., 1990s, 2000s

### 4️⃣ Descriptive Statistics
Generates summary metrics (count, mean, median, min, max) for numeric features such as:
- IMDb score  
- Duration  
- Budget & Gross  
- Votes and Reviews  

### 5️⃣ Outlier Detection
Uses the **Interquartile Range (IQR)** method to detect outliers in numeric columns.

### 6️⃣ Data Visualization
Visuals are created using **ggplot2** to reveal data patterns:

| Visualization | Description |
|----------------|-------------|
| 🎞️ Histogram | IMDb score distribution |
| ⏱️ Histogram | Movie duration distribution |
| 💰 Scatter Plot | Budget vs Gross revenue (in millions) |
| 🎭 Boxplot | ROI variation across top 10 genres |
| 📅 Line Plot | IMDb rating trends by release year |

---

## 📊 Key Insights
- Most IMDb scores fall between **6.0 – 7.5**.  
- Longer movies generally achieve higher ratings.  
- Higher budgets do not always mean higher ROI.  
- **Drama**, **Comedy**, and **Action** dominate as leading genres.  
- The **2000s** produced a large number of critically rated movies.  

---

## 🧩 Possible Extensions

- 🧠 Build a predictive model for IMDb score or ROI.

- 🧭 Create a Shiny Dashboard for interactive movie insights.

- 🔗 Integrate APIs (e.g., OMDb or TMDb) for extended metadata.

- 📈 Perform trend forecasting for genres and ratings.
---
## 📜 License

This project is created for academic and learning purposes under the MIT License.
You may reuse and modify it with proper attribution.

---

## 🚀 How to Run the Project
1. **Clone the Repository**
   ```bash
   git clone https://github.com/mdnaimul404/IMDb-Movie-Data-Analysis-in-R.git
   cd IMDb-Movie-Data-Analysis-in-R
---
### 👏 Acknowledgment

We would like to thank our course instructor and the AIUB Faculty of Science and Technology (FST) for guidance and resources that helped us complete this analysis.
   
