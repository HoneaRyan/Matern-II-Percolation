#include <iostream>
#include <time.h>
#include <iomanip>
#include <fstream>
#include <random>
#include <omp.h>
#include "Perc_Graph.h"

using namespace std;

void Run(int);

int main() {

	int timer1, timer2, finaltime, i, factors, reps;
	//	double r, a, p;
	/*
	cout << setw(35) << left << "Enter Connection Radius" << ": ";
	cin >> r;
	cout << setw(35) << left << "Enter Matern II Thinning Radius" << ": ";
	cin >> a;
	cout << setw(35) << left << "Enter Connection Probability" << ": ";
	cin >> p; */
	//cout << setw(35) << left << "Enter number of factors" << ": ";
	//cin >> factors;
	cout << setw(35) << left << "Enter number of replicates" << ": ";
	cin >> reps;

	timer1 = time(0);

	Run(reps);

	timer2 = time(0);
	finaltime = timer2 - timer1;
	double simulationNum = reps;
	cout << "Simulation of " << simulationNum << " data points completed in ";
	cout << finaltime / 60 << " minutes and " << finaltime % 60 << " seconds." << endl;
	cout << "Average time per simulation: " << double(finaltime) / double(simulationNum) << " seconds." << endl;
}

void Run(int reps) {
	std::default_random_engine generator(time(NULL));
	ofstream datafile;
	double p,r,a;
	int runs = 0;
	datafile.open("data2.txt");
	datafile << "p r a infclus\n";
	//bool clusterPres = false;
#pragma omp parallel for
	for (int i = 0; i < 2; i++) {
	    for (int j = 0; j < 5; j++) {
		for (int k = 0; k < 9; k++) {
		    for (int l = 0; l < reps; l++) {
				//	p = (i+1)*(1.0/11);  so it runs from 1/11 to 10/11
				p = (i+1)*.333333;
			r = .02702 + j*(2.0/5)*.02702; // so it runs from the avg dist to 3*avg dist
			a = ((k+16.0)/40)*r; // so it runs from 2/5 r to 3/5 r
			
			Graph* percolation = new Graph;
			percolation->createPoints(r, generator);
			percolation->thinPoints(a);
			percolation->createAdjMatrix(r, p);
			bool clusterPres = percolation->hasInfiniteCluster();
			if (clusterPres) {
			    cout << "Simulation " << runs + 1 << " Complete. " << "Cluster Exists." << endl << flush;
			    runs++;
			}
			else {
			    cout << "Simulation " << runs + 1 << " Complete. " << "No cluster.    " << endl << flush;
			    runs++;
			}
			percolation->reset();
#pragma omp critical
			datafile << i+1 << " " << j+1 << " " << k+1 << " " << clusterPres << endl << flush;
			delete percolation;
		    }
		}
	    }
	}
        datafile.close();
}
