help:
	@echo 'make install:          Install package, hook, notebooks and gdslib'
	@echo 'make test:             Run tests with pytest'
	@echo 'make test-force:       Rebuilds regression test'

install: gdslib
	bash install.sh

meep:
	conda install -c conda-forge pymeep

update:
	pur
	pur -r requirements_dev.txt

update-pre:
	pre-commit autoupdate --bleeding-edge

gds:
	python gdsfactory/components/straight.py

gdslib:
	git clone https://github.com/gdsfactory/gdslib.git

test:
	tox -e flake8
	pytest -s

test-force:
	echo 'Regenerating component metadata for regression test. Make sure there are not any unwanted regressions because this will overwrite them'
	rm -rf gds_ref
	rm -rf gdsfactory/tests/test_components.gds
	pytest --force-regen

test-plugins:
	pytest gdsfactory/simulation/gmeep
	pytest gdsfactory/simulation/modes

retest:
	echo 'Regenerating component metadata for regression test. Make sure there are not any unwanted regressions because this will overwrite them'
	pytest --lf --force-regen

diff:
	python gdsfactory/merge_cells.py

test-notebooks:
	py.test --nbval notebooks

cov:
	pytest --cov=gdsfactory

venv:
	python3 -m venv env

pipenv:
	pip install pipenv --user
	pipenv install

pyenv3:
	pyenv shell 3.7.2
	virtualenv venv
	source venv/bin/activate
	python -V # Print out python version for debugging
	which python # Print out which python for debugging
	python setup.py develop

conda:
	conda env create -f environment.yml
	echo 'conda env installed, run `conda activate gdsfactory` to activate it'

mypy:
	mypy gdsfactory --ignore-missing-imports

build:
	python setup.py sdist bdist_wheel

devpi-release:
	pip install devpi-client wheel
	devpi upload --format=bdist_wheel,sdist.tgz

release:
	git push origin --tags

lint:
	tox -e flake8

pylint:
	pylint --rcfile .pylintrc gdsfactory/

lintdocs:
	flake8 --select RST

lintdocs2:
	pydocstyle gdsfactory

doc8:
	doc8 docs/

autopep8:
	autopep8 --in-place --aggressive --aggressive **/*.py

codestyle:
	pycodestyle --max-line-length=88

doc:
	python docs/write_components_doc.py

.PHONY: gdsdiff build conda
