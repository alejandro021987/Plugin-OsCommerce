<?php
class ControlFraudeFactory {

	const RETAIL = "Retail";
	const SERVICE = "Service";
	const DIGITAL_GOODS = "Digital Goods";
	const TICKETING = "Ticketing";

	public static function get_ControlFraude_extractor($vertical, $order, $logger){
		$instance;
		switch ($vertical) {
			case ControlFraudeFactory::RETAIL:
				$instance = new ControlFraude_Retail($order, $logger);
			break;
			
			case ControlFraudeFactory::SERVICE:
				$instance = new ControlFraude_Service($order, $logger);
			break;
			
			case ControlFraudeFactory::DIGITAL_GOODS:
				$instance = new ControlFraude_DigitalGoods($order, $logger);
			break;
                
            case ControlFraudeFactory::TICKETING:
                $instance = new ControlFraude_Ticketing($order, $logger);

			default:
				$instance = new ControlFraude_Retail($order, $logger);
			break;
		}
		return $instance;
	}
}
