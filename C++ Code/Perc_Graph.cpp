#include "Perc_Graph.h"
#include "Perc_Point.h"
#include <random>
#include <iostream>
#include <time.h>

Graph::Graph() {
	length_ = 0;
	visited_.push_back(0);
	infCluster_ = false;
}

void Graph::createPoints(double r, std::default_random_engine generator) {
	
	double min = -1.0 - r;
	double max = 1.0 + r;
	double randn;
	std::poisson_distribution<int> distribution(7500*((2.0+2.0*r)*(2.0+2.0*r)/4.0));

	// distributes poisson points of lambda intensity
	
	lambdaIntensity_ = distribution(generator);
	points_ = new Point[lambdaIntensity_];
	
	for (int i = 0; i < lambdaIntensity_; i++) {
		randn = (((double)rand()*(max - min) / RAND_MAX) + min);
		points_[i].setX(randn);
		randn = (((double)rand()*(max - min) / RAND_MAX) + min);
		points_[i].setY(randn);
	}
}


/* This method does a number of things. The first thing it does is create 
a Point array of max size lambdaIntensity with the first point being initialized
as the origin of the graph. Following that, it checks the original array and any
point that is within a deletion radius is set as (0,0). After that check, any point
that is not (0,0) is transferred into the new array. Following that, our points_
array will be set to the new one.*/
void Graph::thinPoints(double a) {
	Point* temparray;
	temparray = new Point[(lambdaIntensity_+1)];

	// setting first point of thinned array at the origin
	temparray[0].setX(0.0); 
	temparray[0].setY(0.0);
	length_ = 1;

	for (int i = 0; i < (lambdaIntensity_-1); i++) {
		for (int j = (i + 1); j < lambdaIntensity_; j++) {
			if (distance_(points_[i], points_[j]) <= a) {
				points_[i].setX(0.0);
				points_[i].setY(0.0);
			}
		}
	}

	for (int i = 0; i < lambdaIntensity_; i++) {
		if (!(points_[i].getX() == 0.0 && points_[i].getY() == 0.0)) {
			temparray[length_].setX(points_[i].getX());
			temparray[length_].setY(points_[i].getY());
			temparray[length_].checkOutside();
			length_++;
		}
	}

	delete points_;

	points_ = new Point[length_];
	for (int i = 0; i < length_; i++) {
		points_[i] = temparray[i];
	}

	
	delete temparray;
}

void Graph::createAdjMatrix(double r, double p) {
	adjMatrix_ = new bool[length_ * length_];
	// So any reference to the array will be
	// in the form i*length_+j]

	// initializes diagonal as 0s
	for (int i = 0; i < length_; i++) {
		adjMatrix_[i*length_ + i] = false;
	}

	// constructs remainder of adjacency matrix
	for (int i = 0; i < (length_ - 1); i++) {
		for (int j = (i + 1); j < length_; j++) {
			if ((distance_(points_[i], points_[j]) <= r) && (((double)rand() / RAND_MAX) <= p)) {
				adjMatrix_[i*length_ + j] = true;
				adjMatrix_[j*length_ + i] = true;
			}
			else {
				adjMatrix_[i*length_ + j] = false;
				adjMatrix_[j*length_ + i] = false;
			}
		}
	}
}


bool Graph::hasInfiniteCluster() {

	hasEdge(points_[0], 0);

	return infCluster_;
}

void Graph::reset() {
	visited_.clear();
	visited_.push_back(0);
	delete [] points_;
	delete [] adjMatrix_;
	int length_ = 0;
	infCluster_ = false;
}
