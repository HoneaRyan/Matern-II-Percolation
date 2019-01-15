#ifndef Perc_Graph_h
#define Perc_Graph_h

#include<vector>
#include<iostream>
#include "Perc_Point.h"
#include <random>
#include <cmath>
#include <vector>

class Graph {
private:
	Point* points_;
	bool* adjMatrix_;
	int lambdaIntensity_;
	int length_;
	bool infCluster_;
	std::vector<int> visited_;


	double distance_(Point p1, Point p2) {
		double xdist, ydist, dist;
		xdist = (p1.getX() - p2.getX())*(p1.getX() - p2.getX());
		ydist = (p1.getY() - p2.getY())*(p1.getY() - p2.getY());
		dist = sqrt(xdist + ydist);
		return dist;
	}


	bool alreadyVisited(int val) {
		for (int i = 0; i < visited_.size(); i++) {
			if (visited_[i] == val) { 
				return true; 
			}
		}
		return false;
	}


	bool hasEdge(Point p1, int row) {
		int edges = 0;
		if (infCluster_) { return true; }
		for (int i = 0; i < length_; i++) {
			if (adjMatrix_[row*length_ + i]) {
				edges++;
				//std::cout << "Node " << row << " had edge with " << i << std::endl;
			}
		}
		for (int i = 0; i < edges; i++) {
			for (int i = 1; i < length_; i++) {
				if (alreadyVisited(i) == false) { //checks to make sure no back tracking
					//std::cout << adjMatrix_[row*length_ + i] << std::endl;

						if (adjMatrix_[row*length_ + i]) {
							visited_.push_back(i);
							//std::cout << "Point " << row << " has edge with " << i;
							//std::cout << " at location " << points_[i].getX() << " " << points_[i].getY();
							//std::cout << " which is " << distance_(points_[i], points_[0]) << " from origin." << std::endl;

							if (distance_(points_[i], points_[0]) >= 1.0) {
								infCluster_ = true;
								return true;
							}
							else if (infCluster_) { return true; }
							else { hasEdge(points_[i], i); }
						}
				}				
			}
		}

		return false;
	}

public:
	Graph();
	void createPoints(double, std::default_random_engine);
	void thinPoints(double);
	void createAdjMatrix(double, double);
	bool hasInfiniteCluster();
	void reset();
};



#endif