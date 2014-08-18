all: pdf png

pdf: Resources.pdf

png: LifeSupport.png ProductionLine.png Extending.png

clean:
	rm *.pdf *.png

LifeSupport.pdf: LifeSupport.dot
	dot -Tpdf -o LifeSupport.pdf LifeSupport.dot

LifeSupport.png: LifeSupport.dot
	dot -Tpng -o LifeSupport.png LifeSupport.dot

ProductionLine.pdf: ProductionLine.dot
	dot -Tpdf -o ProductionLine.pdf ProductionLine.dot

ProductionLine.png: ProductionLine.dot
	dot -Tpng -o ProductionLine.png ProductionLine.dot

Extending.pdf: Extending.dot
	dot -Tpdf -o Extending.pdf Extending.dot

Extending.png: Extending.dot
	dot -Tpng -o Extending.png Extending.dot

Resources.pdf: LifeSupport.pdf ProductionLine.pdf Extending.pdf
	convert
