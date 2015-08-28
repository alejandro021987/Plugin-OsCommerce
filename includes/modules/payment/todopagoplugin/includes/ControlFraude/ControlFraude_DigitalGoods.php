<?php
class ControlFraude_DigitalGoods extends ControlFraude{

	protected function completeCFVertical(){
		return $this->getMultipleProductsInfo();
	}
}