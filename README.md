# MATLAB Fall 2015 – Research Plan

> * Group Name: AntsInThePants
> * Group participants names: Hasler, Florian; Heinzmann, Matthias; Urech, Andreas; Werner, Dominik
> * Project Title: Dessert Ant Adaptive Orientation

## General Introduction

The Desert Ant (Cataglyphis) is an interesting creature. It lives in the desert where conditions are very harsh. The ant will die if it remains outside its nest for too long because of the hot sand it crawls on. It is vital for the ants survival that it has a sophisticated way to navigate through the pans of sand that make out most of its habitat. Since the early 20th century biologists have been fascinated by this ant and its navigation thourgh the desert. Recently there has been speculation about the methods that are utilized by these ants to navigate between sources of food and their nest. If we could reproduce the path-pattern observed by real ants with a good model we would be able to predict how they would react if something would change in their ecosystem.
We will base our work upon an essay written by R. Wehner with the title "Desert ant navigation: how miniature brains solve complex tasks". In this essay he suggests 3 methods of navigation which the ants can use, namely path integration, pheromones and visual landmark recognition. In his final conclusion he considers all 3 methods important and assumes that the ant has a way of adapting the priority of each mechanism according to the current situation.
In Previous years a group called gordonteam already implemented a model based on the before mentioned article. In the report they noted that their path integration did not work and that they were not able to combine all 3 methods. Our plan is to extend upon their work and fix the problems as well as to bind all 3 methods thogether. Furthermore we want to implement a memory system along with a learing machine wich will allow the ant to dynamically adapt to an environment.

## The Model

For our simulation we will use an agent based model where every agent will be representing an ant. To be able to compare our model with the real world data we have to keep track of serveral different variables:
> * nestLocation: This is a 2D vector wich indicates the position of the nest inside a sand pan.
> * foodSourceLocation(s): These 2D vectors symbolize the location of a food source which the ant will have to travel to. It should be possible to implement an ephemeral (non-renewable) food source so the ant has to look for a new one if the first does not yield food anymore.
> * pheromoneParticles: Objects that represent pheromone particles with a specific lifetime. These pheromones can be produced by ants.
> * ants: The agents themselve who contain their position data and other information to track the simulation.
> * landmarks: Objects that symbolize visual orientation points for the ants.

All the above mentioned variables will be classes implemed in Matlab. Matlab offers the possibility of working with classes which should be benefitial when using an agent based model. Furthermore our predecessors already implemed classes which we can extend as the need arises.
Extensions we may implement during our project:
> * machineLearningAlgorithm in the ants class
> * putting the foodSourceLocation inside of a class which enables us to give it properties such as the amount of food which the ants can harvest.
> * implementing a decision function which tells the ant which navigation method it should use for how long.
> * implementing a rating function which evaluates how successful a trip of an ant was (could be used by the learing algorithm).
> * implementing a basic starter script which makes the usage of the simulation userfriendly and as self explenatory as possible.

## Fundamental Questions

At the end of this project we want to have a model which is able to simulate realistic desert ant behavior in a variable setup. If this should not be possible we want to be able to tell which factors make such a model difficult to implemet and how it could probably be achieved after all.
Core questions will be:
> * Is the model accurate, therefore do the walking patterns that we've simulated match the empirical ones?
>  * Do they match in length?
>  * Do they match in directions?
>  * Do they match in distribution?
>  * How does the memory effect the path pattern?
>  * Also, do the decisions which the ants learned make sense?
> * Are we able to predict what happens if we alter the environment? (depends on the question beforehand)
>  * Can the ants survive if we rid the environment completely of any landmarks?
>  * Can the ants survive if the landmarks constantly change?
>  * Can the ants survive if temperature would increase (pheromones will last shorter, ants have to come back to the nest faster)?

As indicators of survival and the other parameters we can use the success-funciton as well as the agent properties that belong to our model.

## Expected Results

The article we base our work upon does state that its conclusions might be flawd in some ways. The provided experimental data however looks promising so we expec

> * That the patterns should be produced in a similar way as in the experiments. Therefore:
>  * That the lengths of the paths match with the real ones.
>  * That the directions of the paths are chosen as in reality.
>  * That the ants distribute themselves reasonable among the food sources.
>  * That the implemented memory causes the ants to extend the search radius once a food source has run out. This means the ant should look for new sources starting from the old source.
>  * That the ants can switch to another method of navigation should the need arise?
> * That the ants behavior becomes predictable. Therefore:
>  * That ants can survive if landmak navigation is impossible by using the other 2 methods.
>  * That ants can survive even if the conditions of their environment gets harsher provided they have enough resources in their proximity.

## References 

For this project we will use the following references:
> * "Desert ant navigation: how miniature brains solve complex tasks" by R. Wehner
> * "Path integration in desert ants, Cataglyphis fortis" by M. Müller and R. Wehner

We will start off our project on the work of gordonteam. They have worked on the subject and came up with a model which does not take into account the afore mentioned changes we intend to implement. Also we will try to fix their path integrator which they could not get working during the project.

project of gordonteam: https://github.com/msssm/desert_ant_behavior_gordonteam

## Research Methods

Agent-Based Model


## Other

(mention datasets you are going to use) TBD
