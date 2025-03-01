%% Machine Learning: Programming Exercise 2 
%% Logistic Regression
% In this exercise, you will implement logistic regression and apply it to two 
% different datasets.
%% Files needed for this exercise
% * |ex2.mlx| - MATLAB Live Script that steps you through the exercise
% * ex2data1.txt - Training set for the first half of the exercise
% * ex2data2.txt| |- Training set for the second half of the exercise
% * |submit.m| - Submission script that sends your solutions to our servers
% * |mapFeature.m| - Function to generate polynomial features
% * |plotDecisionBoundary.m| - Function to plot classifier's decision boundary
% * *|plotData.m| - Function to plot 2D classification data
% * *|sigmoid.m| - Sigmoid function
% * *|costFunction.m| - Logistic regression cost function
% * *|predict.m| - Logistic regression prediction function
% * |*costFunctionReg.m| - Regularized logistic regression cost function
% 
% _**indicates files you will need to complete*_
%% Confirm that your Current Folder is set correctly
% Click into this section, then click the 'Run section' button above. This will 
% execute the |dir| command below to list the files in your Current Folder. The 
% output should contain all of the files listed above and the 'lib' folder. If 
% it does not, right-click the 'ex2' folder and select 'Open' before proceding 
% or see the instructions in |README.mlx| for more details.

dir
%% Before you begin
% The workflow for completing and submitting the programming exercises in MATLAB 
% Online differs from the original course instructions. Before beginning this 
% exercise, make sure you have read through the instructions in |README.mlx| which 
% is included with the programming exercise files. |README| also contains solutions 
% to the many common issues you may encounter while completing and submitting 
% the exercises in MATLAB Online. Make sure you are following instructions in 
% |README| and have checked for an existing solution before seeking help on the 
% discussion forums.
%% 1. Logistic Regression
% In this part of the exercise, you will build a logistic regression model to 
% predict whether a student gets admitted into a university. Suppose that you 
% are the administrator of a university department and you want to determine each 
% applicant's chance of admission based on their results on two exams. You have 
% historical data from previous applicants that you can use as a training set 
% for logistic regression. For each training example, you have the applicant's 
% scores on two exams and the admissions decision.
% 
%     Your task is to build a classification model that estimates an applicant's 
% probability of admission based the scores from those two exams. |ex2.mlx| will 
% guide you through the exercise. To begin, run the code below to load the data 
% into MATLAB.

% Load Data
% The first two columns contain the exam scores and the third column contains the label.
data = load('ex2data1.txt');
X = data(:, [1, 2]); y = data(:, 3);
%% 1.1 Visualizing the data
% Before starting to implement any learning algorithm, it is always good to 
% visualize the data if possible. The code below will load the data and display 
% it on a 2-dimensional plot by calling the function |plotData|. You will now 
% complete the code in |plotData| so that it displays a figure like Figure 1, 
% where the axes are the two exam scores, and the positive and negative examples 
% are shown with different markers.
% 
% 
% 
% To help you get more familiar with plotting, we have left |plotData.m| 
% empty so you can try to implement it yourself. However, this is an optional 
% (ungraded) exercise. We also provide our implementation below so you can copy 
% it or refer to it. If you choose to copy our example, make sure you learn what 
% each of its commands is doing by consulting the MATLAB documentation.
%%
% 
%       % Find Indices of Positive and Negative Examples
%       pos = find(y==1); neg = find(y == 0);
%       % Plot Examples
%       plot(X(pos, 1), X(pos, 2), 'k+','LineWidth', 2, 'MarkerSize', 7);
%       plot(X(neg, 1), X(neg, 2), 'ko', 'MarkerFaceColor', 'y','MarkerSize', 7);
%
% 
% Once you have added your own or the above code to |plotData.m|, run the 
% code in this section to call the |plotData| function.

% Plot the data with + indicating (y = 1) examples and o indicating (y = 0) examples.
plotData(X, y);
 
% Labels and Legend
xlabel('Exam 1 score')
ylabel('Exam 2 score')

% Specified in plot order
legend('Admitted', 'Not admitted')
%% 1.2 Implementation
%% 1.2.1 Warmup exercise: sigmoid function
% Before you start with the actual cost function, recall that the logistic regression 
% hypothesis is defined as:
% 
% $$ h_{\theta}(x) = g(\theta^Tx),$$
% 
% where function $g$ is the sigmoid function. The sigmoid function is defined 
% as:
% 
% $$g(z) = \frac{1}{1+e^{-z}}$$
% 
%     Your first step is to implement this function in |sigmoid.m| so it 
% can be called by the rest of your program. When you are finished, try testing 
% a few values by calling |sigmoid(x)| in the code section below. For large positive 
% values of |x|, the sigmoid should be close to 1, while for large negative values, 
% the sigmoid should be close to 0. Evaluating |sigmoid(0)| should give you exactly 
% 0.5. *Your code should also work with vectors and matrices*. For a matrix, your 
% function should perform the sigmoid function on every element.

% Provide input values to the sigmoid function below and run to check your implementation
sigmoid([-3 -2 -1; -0.5 0 0.5;1 2 3])
%% 
% _You should now submit your solutions.  Enter |_*submit|_* at the command 
% prompt, then enter or confirm your login and token when prompted._
%% 1.2.2 Cost function and gradient
% Now you will implement the cost function and gradient for logistic regression. 
% Complete the code in |costFunction.m| to return the cost and gradient. Recall 
% that the cost function in logistic regression is
% 
% $$J(\theta) =\frac{1}{m}\sum_{i=1}^m{\left[-y^{(i)} \log(h_{\theta}(x^{(i)}))- 
% (1 -y^{(i)}) \log(1- h_{\theta}(x^{(i)}))\right],$$
% 
% and the gradient of the cost is a vector of the same length as $\theta$ 
% where the $j$th element (for $j = 0,\; 1,\ldots, n)$ is defined as follows:
% 
% $$\frac{\partial J(\theta)}{\partial \theta_j} = \frac{1}{m}\sum_{i=1}^m{\left( 
% h_\theta(x^{(i)})-y^{(i)}\right)x_j^{(i)}$$
% 
% Note that while this gradient looks identical to the linear regression 
% gradient, the formula is actually different because linear and logistic regression 
% have different definitions of $h_{\theta}(x)$. Once you are done, run the code 
% sections below to set up your data and call your |costFunction| using the initial 
% parameters of $\theta$. You should see that the cost is about 0.693 and gradients 
% of about -0.1000,  -12.0092, and -11.2628

%  Setup the data matrix appropriately
X = data(:, [1, 2]);
[m, n] = size(X);

% Add intercept term to X
X = [ones(m, 1) X];

% Initialize the fitting parameters
initial_theta = zeros(n + 1, 1);

% Compute and display the initial cost and gradient
[cost, grad] = costFunction(initial_theta, X, y);
fprintf('Cost at initial theta (zeros): %f\n', cost);
disp('Gradient at initial theta (zeros):'); disp(grad);
%% 1.2.3 Learning parameters using |fminunc|
% In the previous assignment, you found the optimal parameters of a linear regression 
% model by implementing gradent descent. You wrote a cost function and calculated 
% its gradient, then took a gradient descent step accordingly. This time, instead 
% of taking gradient descent steps, you will use a MATLAB built-in function called 
% |fminunc|. 
% 
%     MATLAB's |fminunc| is an optimization solver that finds the minimum 
% of an unconstrained* function. For logistic regression, you want to optimize 
% the cost function $J(\theta)$ with parameters. Concretely, you are going to 
% use |fminunc| to find the best parameters $\theta$ for the logistic regression 
% cost function, given a fixed dataset (of $X$ and $y$ values). You will pass 
% to |fminunc| the following inputs:
% 
% * The initial values of the parameters we are trying to optimize.
% * A function that, when given the training set and a particular $\theta$ computes 
% the logistic regression cost and gradient with respect to $\theta$ for the dataset 
% $(X, y)$
% 
% _*Constraints in optimization often refer to constraints on the parameters, 
% for example, constraints that bound the possible values _$\theta$_ can take 
% (e.g. _$\theta<1$_). Logistic regression does not have such constraints since 
% _$\theta$_ is allowed to take any real value._
% 
% 
% 
% We already have code written below to call |fminunc| with the correct arguments:
% 
% * We first define the options to be used with |fminunc|. Specically, we set 
% the |GradObj| option to |on|, which tells |fminunc| that our function returns 
% both the cost and the gradient. This allows |fminunc| to use the gradient when 
% minimizing the function. 
% * Furthermore, we set the |MaxIter| option to 400, so that |fminunc| will 
% run for at most 400 steps before it terminates. 
% * To specify the actual function we are minimizing, we use a 'short-hand' 
% for specifying functions with: |@(t)(costFunction(t,X,y))|. This creates a function, 
% with argument |t|, which calls your |costFunction|. This allows us to wrap the 
% |costFunction| for use with |fminunc|.
% * If you have completed the |costFunction| correctly, |fminunc| will converge 
% on the right optimization parameters and return the final values of the cost 
% and $\theta$. Notice that by using |fminunc|, you did not have to write any 
% loops yourself, or set a learning rate like you did for gradient descent. This 
% is all done by |fminunc|: you only needed to provide a function calculating 
% the cost and the gradient.
% * Once |fminunc| completes, the remaining code will call your |costFunction| 
% function using the optimal parameters of $\theta$. You should see that the cost 
% is about 0.203. This final $\theta$ value will then be used to plot the decision 
% boundary on the training data, resulting in a figure similar to Figure 2. We 
% also encourage you to look at the code in |plotDecisionBoundary.m| to see how 
% to plot such a boundary using the $\theta$ values.
% 
% 
% 
% 
% 
% Run the code below and verify the results.

%  Set options for fminunc
options = optimoptions(@fminunc,'Algorithm','Quasi-Newton','GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Print theta
fprintf('Cost at theta found by fminunc: %f\n', cost);
disp('theta:');disp(theta);

% Plot Boundary
plotDecisionBoundary(theta, X, y);
% Add some labels 
hold on;
% Labels and Legend
xlabel('Exam 1 score')
ylabel('Exam 2 score')
% Specified in plot order
legend('Admitted', 'Not admitted')
hold off;
%% 1.2.4 Evaluating logistic regression
% After learning the parameters, you can use the model to predict whether a 
% particular student will be admitted. For a student with an Exam 1 score of 45 
% and an Exam 2 score of 85, you should expect to see an admission probability 
% of 0.776. Another way to evaluate the quality of the parameters we have found 
% is to see how well the learned model predicts on our training set. In this part, 
% your task is to complete the code in |predict.m|. The predict function will 
% produce '1' or '0' predictions given a dataset and a learned parameter vector 
% $\theta$.
% 
%     After you have completed the code in |predict.m|, the code below will 
% proceed to report the training accuracy of your classifier by computing the 
% percentage of examples it got correct. 

%  Predict probability for a student with score 45 on exam 1  and score 85 on exam 2 
prob = sigmoid([1 45 85] * theta);
fprintf('For a student with scores 45 and 85, we predict an admission probability of %f\n\n', prob);
% Compute accuracy on our training set
p = predict(theta, X);
fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);
%% 
% _You should now submit your solutions.  Enter |_*submit|_* at the command 
% prompt, then enter or confirm your login and token when prompted._
%% 2. Regularized logistic regression
% In this part of the exercise, you will implement regularized logistic regression 
% to predict whether microchips from a fabrication plant passes quality assurance 
% (QA). During QA, each microchip goes through various tests to ensure it is functioning 
% correctly. Suppose you are the product manager of the factory and you have the 
% test results for some microchips on two different tests. From these two tests, 
% you would like to determine whether the microchips should be accepted or rejected. 
% To help you make the decision, you have a dataset of test results on past microchips, 
% from which you can build a logistic regression model.
%% 2.1 Visualizing the data
% Similar to the previous parts of this exercise, |plotData| is used in the 
% code below to generate a figure like Figure 3, where the axes are the two test 
% scores, and the positive ($y=1,$  accepted) and negative ($y=0,$ rejected) examples 
% are shown with different markers. 
% 
% 
% 
% Run the code below and confirm you plot matches Figure 3.

%  The first two columns contains the X values and the third column
%  contains the label (y).
data = load('ex2data2.txt');
X = data(:, [1, 2]); y = data(:, 3);

plotData(X, y);
% Put some labels 
hold on;
% Labels and Legend
xlabel('Microchip Test 1')
ylabel('Microchip Test 2')
% Specified in plot order
legend('y = 1', 'y = 0')
hold off;
%% 
%         Figure 3 shows that our dataset cannot be separated into positive 
% and negative examples by a straight-line through the plot. Therefore, a straightforward 
% application of logistic regression will not perform well on this dataset since 
% logistic regression will only be able to find a linear decision boundary.
%% 2.2 Feature mapping
% One way to fit the data better is to create more features from each data point. 
% In the provided function |mapFeature.m|, we will map the features into all polynomial 
% terms of $x_1$ and $x_2$ up to the sixth power.
% 
% $$\text{mapFeature}\left(x\right)=\left\lbrack \begin{array}{c}1\\x_1 \\x_2 
% \\x_1^2 \\x_1 x_2 \\x_2^2 \\x_1^3 \\\vdots \text{ }\\x_1 x_2^5 \\x_2^6 \end{array}\right\rbrack$$
% 
%     As a result of this mapping, our vector of two features (the scores 
% on two QA tests) has been transformed into a 28-dimensional vector. A logistic 
% regression classifier trained on this higher-dimension feature vector will have 
% a more complex decision boundary and will appear nonlinear when drawn in our 
% 2-dimensional plot. 
% 
%     Run the code below to map the features.

% Add Polynomial Features
% Note that mapFeature also adds a column of ones for us, so the intercept term is handled
X = mapFeature(X(:,1), X(:,2));
%% 
%     While the feature mapping allows us to build a more expressive classifier, 
% it also more susceptible to overfitting. In the next parts of the exercise, 
% you will implement regularized logistic regression to fit the data and also 
% see for yourself how regularization can help combat the overfitting problem.
%% 2.3 Cost function and gradient
% Now you will implement code to compute the cost function and gradient for 
% regularized logistic regression. Complete the code in |costFunctionReg.m| to 
% return the cost and gradient. Recall that the regularized cost function in logistic 
% regression is
% 
% $$J(\theta) =\frac{1}{m}\sum_{i=1}^m{\left[-y^{(i)} \log(h_{\theta}(x^{(i)}))-(1-y^{(i)}) 
% \log(1-h_{\theta}(x^{(i)}))\right]+\frac{\lambda}{2m}\sum_{j=1}^n{\theta_j^2},$$
% 
% Note that you should not regularize the parameter $\theta_0$. In MATLAB, 
% recall that indexing starts from 1, hence, you should not be regularizing the 
% |theta(1)| parameter (which corresponds to $\theta_0$) in the code. The gradient 
% of the cost function is a vector where the $j\mathrm{th}$ element is defined 
% as follows:
% 
% $$\frac{\partial J(\theta)}{\partial \theta_j} = \frac{1}{m}\sum_{i=1}^m{\left( 
% h_\theta(x^{(i)})-y^{(i)}\right)x_j^{(i)}\qquad \mathrm{for}\;j=0,$$
% 
% $$\frac{\partial J(\theta)}{\partial \theta_j} = \left( \frac{1}{m}\sum_{i=1}^m{\left( 
% h_\theta(x^{(i)})-y^{(i)}\right)x_j^{(i)}} \right)+\frac{\lambda}{m}\theta_j\qquad 
% \mathrm{for}\;j\geq1,$$
% 
% Once you are done, run the code below to call your |costFunctionReg| function 
% using the initial value of $\theta$ (initialized to all zeros). You should see 
% that the cost is about 0.693.

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Set regularization parameter lambda to 1
lambda = 1;

% Compute and display initial cost and gradient for regularized logistic regression
[cost, grad] = costFunctionReg(initial_theta, X, y, lambda);
fprintf('Cost at initial theta (zeros): %f\n', cost);
% plotDecisionBoundary(theta,X,y)
%% 
% _You should now submit your solutions.  Enter |_*submit|_* at the command 
% prompt, then enter or confirm your login and token when prompted._
%% 2.3.1 Learning parameters using |fminunc|
% Similar to the previous parts, the next step is to use |fminunc| to learn 
% the optimal parameters. If you have completed the cost and gradient for regularized 
% logistic regression (|costFunctionReg.m|) correctly, you should be able to run 
% the code in the following sections to learn the parameters using |fminunc| for 
% multiple values of $\lambda$.
%% 2.4 Plotting the decision boundary
% To help you visualize the model learned by this classifier, we have provided 
% the function |plotDecisionBoundary.m| which plots the (nonlinear) decision boundary 
% that separates the positive and negative examples. In |plotDecisionBoundary.m|, 
% we plot the nonlinear decision boundary by computing the classifier's predictions 
% on an evenly spaced grid and then drew a contour plot of where the predictions 
% change from $y = 0$ to $y = 1$. After learning the parameters, the code in the 
% next section will plot a decision boundary similar to Figure 4.
% 
% 
%% 2.5 Optional (ungraded) exercises
% In this part of the exercise, you will get to try out different regularization 
% parameters for the dataset to understand how regularization prevents overfitting. 
% Notice the changes in the decision boundary as you vary $\lambda$. With a small 
% $\lambda$, you should find that the classifier gets almost every training example 
% correct, but draws a very complicated boundary, thus overfitting the data (Figure 
% 5). 
% 
% 
% 
%     This is not a good decision boundary: for example, it predicts that 
% a point at $x = (0.25, 1.5)$ is accepted $(y = 1)$, which seems to be an incorrect 
% decision given the training set. With a larger $\lambda$, you should see a plot 
% that shows an simpler decision boundary which still separates the positives 
% and negatives fairly well. However, if $\lambda$ is set to too high a value, 
% you will not get a good fit and the decision boundary will not follow the data 
% so well, thus underfitting the data (Figure 6).
% 
% 
% 
% Use the control below to try the following values of $\lambda$: 0, 1, 10, 
% 100. 
% 
% * How does the decision boundary change when you vary $\lambda$? 
% * How does the training set accuracy vary?

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

lambda = 1;
% Set Options
options = optimoptions(@fminunc,'Algorithm','Quasi-Newton','GradObj', 'on', 'MaxIter', 1000);

% Optimize
[theta, J, exit_flag] = fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);
% Plot Boundary
plotDecisionBoundary(theta, X, y);
hold on;
title(sprintf('lambda = %g', lambda))

% Labels and Legend
xlabel('Microchip Test 1')
ylabel('Microchip Test 2')
f=gcf;
legend('y = 1', 'y = 0', 'Decision boundary')
hold off;saveas(f, 'image_1.png');



% Compute accuracy on our training set
p = predict(theta, X);

fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);
%% 
% _You do not need to submit any solutions for these optional (ungraded) 
% exercises._
%% Submission and Grading
% After completing various parts of the assignment, be sure to use the |submit| 
% function system to submit your solutions to our servers. The following is a 
% breakdown of how each part of this exercise is scored.
% 
% 
% 
% You are allowed to submit your solutions multiple times, and we will take 
% only the highest score into consideration.