# DeprecationRecommenderSpec

## How to install it?

To install `DeprecationRecommenderSpec`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'DeprecationRecommenderSpec';
  repository: 'github://olekscode/DeprecationRecommenderSpec/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `DeprecationRecommenderSpec` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'DeprecationRecommenderSpec'
  with: [ spec repository: 'github://olekscode/DeprecationRecommenderSpec/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?
