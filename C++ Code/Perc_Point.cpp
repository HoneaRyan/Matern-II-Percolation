#include "Perc_Point.h"
#include<cmath>

Point::Point() {

	x_ = 0.0;
	y_ = 0.0;
	isOutside_ = false;
}

Point::Point(double x, double y) {
	double squareSum;
	x_ = x;
	y_ = y;
	if (sqrt(x*x + y*y) > 1) { isOutside_ = true; }
}

double Point::getX() {
	return x_;
}

double Point::getY() {
	return y_;
}

bool Point::isOutside() {
	return isOutside_;
}

void Point::setX(double x) {
	x_ = x;
}

void Point::setY(double y) {
	y_ = y;
}

void Point::checkOutside() {
	if (sqrt(x_*x_ + y_*y_) >= 1.0) { isOutside_ = true; }
}

bool Point::Outside() {
	if (sqrt(x_*x_ + y_*y_) >= 1.0) { isOutside_ = true; }
	return false;
}
