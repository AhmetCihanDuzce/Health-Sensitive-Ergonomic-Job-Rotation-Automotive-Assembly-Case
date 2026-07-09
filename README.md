# Health-Sensitive-Ergonomic-Job-Rotation-Automotive-Assembly-Case

## Overview

This repository presents a **bi-objective lexicographic optimization model** for the Health-Sensitive Ergonomic Job Rotation Problem.

The mathematical model is implemented using **IBM ILOG CPLEX Optimization Programming Language (OPL)** and is intended to be executed in **IBM ILOG CPLEX Optimization Studio**.

The model integrates health- and ergonomics-oriented decision criteria into the job rotation planning process while ensuring operational feasibility. Although the motivating application is an automotive assembly case, the model is formulated in a general manner and can be adapted to different production environments by providing an appropriate input dataset.

---

## Methodology

The optimization model follows a **lexicographic (hierarchical) bi-objective optimization** approach.

Instead of optimizing multiple objectives simultaneously through aggregation, the objectives are optimized sequentially according to predefined priority levels. The optimal value of the higher-priority objective is preserved while optimizing the subsequent objective.

---

## Model Characteristics

* Bi-objective mathematical programming model
* Lexicographic optimization approach
* Implemented in IBM ILOG CPLEX OPL and compatible with IBM ILOG CPLEX Optimization Studio
* Designed for ergonomic and health-sensitive job rotation problems
* Easily adaptable to different datasets and production environments

---

## Repository Structure

```text
Health-Sensitive-Ergonomic-Job-Rotation-Automotive-Assembly-Case/
│
├── rotasyon.mod              # OPL optimization model
├── rotasyon.dat              # Example input data (optional)
├── rotasyon.ops              # OPL project configuration (optional)
└── README.md
```

---

## Software Requirements

* IBM ILOG CPLEX Optimization Studio

---

## Running the Model

1. Open the project in IBM ILOG CPLEX Optimization Studio.
2. Load the desired `.mod` file.
3. Associate the model with any compatible `.dat` file.
4. Activate the objective and run the model. After first solve, set the second objective and fix the first objective value. Then run again.
5. Review the optimization results in the CPLEX Optimization Studio output window.

---

## Input Data

The optimization model is independent of any specific dataset.

Users may employ their own datasets provided that they conform to the parameter definitions used in the OPL model. Consequently, the model can be adapted to various production systems, manufacturing environments, and workforce configurations without modifying the mathematical formulation.

---

## Output

Depending on the supplied dataset, the model generates optimized job rotation plans together with the corresponding objective function values and decision variable assignments.

---

## Customization

The model can be extended or customized by:

* modifying parameter values,
* introducing additional constraints,
* redefining objective priorities(be careful, needs attention),
* adapting the formulation to different production systems, and
* incorporating additional ergonomic or health-related performance measures.

---

## Citation

If this repository contributes to your research, please cite the associated publication once available.

```text
Citation information will be added after publication.
```

---

## License

GPL-3.0

---

## Disclaimer

This repository is intended for research and educational purposes. Users are encouraged to adapt and extend the optimization model for their own applications while appropriately acknowledging the original work.
