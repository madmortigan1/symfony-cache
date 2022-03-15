<?php

namespace App\Controller;

use App\Entity\Settings;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Contracts\Cache\ItemInterface;
use Symfony\Contracts\Cache\TagAwareCacheInterface;

class DefaultController extends AbstractController
{
    /**
     * @Route("/default", name="default")
     */
    public function index(TagAwareCacheInterface $redisCache, EntityManagerInterface $em): Response
    {
        $a = 10;
        $redisCache->delete('foo.bar.baz');
        $value = $redisCache->get('foo.bar.baz', function(ItemInterface $item) use($em){
            $item->tag(['foo']);
            $item->expiresAfter(5);
    
            /** @var Settings[] $result */
            $result = [];
            $repo = $em->getRepository(Settings::class);
            $result = $repo->findAll();
            $response = [];
            $index = 1;
            foreach ($result as $item)
            {
                $response [] = ['item' => $index, 'value' => $item->getData()];
            }
            $response['Time'] = (new \DateTime('now'))->format('Y-m-d H:m:s');
            return $response;
        });

        return $this->json($value);
    }
}
